#!/usr/bin/env python3
"""Compile Cutiepie skills to agent-native instruction formats.

This is intentionally dependency-free. It supports the common Cutiepie skill shape:

    skills/<name>/SKILL.md

and the Hephaestus-style shape:

    skills/<name>.skill.md
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path

AGENTS = ("claude", "cursor", "codex", "copilot")
MARKER_START = "<!-- cutiepie-compile:{name} -->"
MARKER_END = "<!-- /cutiepie-compile:{name} -->"


@dataclass(frozen=True)
class Skill:
    name: str
    description: str
    body: str


def parse_frontmatter(text: str, path: Path) -> tuple[dict[str, str], str]:
    if not text.startswith("---\n"):
        raise ValueError(f"{path} does not start with YAML frontmatter")

    try:
        _, raw_meta, body = text.split("---", 2)
    except ValueError as error:
        raise ValueError(f"{path} has invalid frontmatter") from error

    meta: dict[str, str] = {}
    current_key: str | None = None
    for raw_line in raw_meta.splitlines():
        line = raw_line.rstrip()
        if not line.strip():
            continue
        if line.startswith((" ", "\t")) and current_key:
            meta[current_key] = f"{meta[current_key]} {line.strip()}".strip()
            continue
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        current_key = key.strip()
        meta[current_key] = value.strip().strip('"').strip("'")

    return meta, body.strip()


def parse_skill(path: Path) -> Skill:
    meta, body = parse_frontmatter(path.read_text(encoding="utf-8"), path)
    name = meta.get("name", "").strip()
    description = meta.get("description", "").strip()
    if not name:
        raise ValueError(f"{path} is missing required frontmatter field: name")
    if not description:
        raise ValueError(f"{path} is missing required frontmatter field: description")
    return Skill(name=name, description=description, body=body)


def discover_skills(source: Path) -> list[Path]:
    if source.is_file():
        return [source]

    paths = list(source.glob("*/SKILL.md"))
    paths.extend(source.glob("*.skill.md"))
    paths.extend(path for path in source.glob("SKILL.md") if path.is_file())
    return sorted(set(paths))


def frontmatter(name: str, description: str) -> str:
    return f"---\nname: {name}\ndescription: {description}\n---\n\n"


def write_claude_like(skill: Skill, output_dir: Path) -> Path:
    skill_dir = output_dir / skill.name
    skill_dir.mkdir(parents=True, exist_ok=True)
    output_path = skill_dir / "SKILL.md"
    output_path.write_text(
        frontmatter(skill.name, skill.description) + skill.body + "\n",
        encoding="utf-8",
    )
    return output_path


def write_cursor(skill: Skill, output_dir: Path) -> Path:
    rules_dir = output_dir / ".cursor" / "rules"
    rules_dir.mkdir(parents=True, exist_ok=True)
    output_path = rules_dir / f"{skill.name}.md"
    output_path.write_text(
        (
            "---\n"
            f"description: {skill.description}\n"
            "globs:\n"
            "alwaysApply: false\n"
            "---\n\n"
            f"# {skill.name}\n\n"
            f"{skill.body}\n"
        ),
        encoding="utf-8",
    )
    return output_path


def write_codex(skill: Skill, output_dir: Path) -> Path:
    output_dir.mkdir(parents=True, exist_ok=True)
    output_path = output_dir / "AGENTS.md"
    start = MARKER_START.format(name=skill.name)
    end = MARKER_END.format(name=skill.name)
    section = (
        f"\n{start}\n\n"
        f"## {skill.name}\n\n"
        f"> {skill.description}\n\n"
        f"{skill.body}\n\n"
        f"{end}\n"
    )

    if output_path.exists():
        existing = output_path.read_text(encoding="utf-8")
        if start in existing:
            pattern = re.escape(start) + r".*?" + re.escape(end)
            existing = re.sub(pattern, section.strip(), existing, flags=re.DOTALL)
            output_path.write_text(
                existing + ("\n" if not existing.endswith("\n") else ""),
                encoding="utf-8",
            )
        else:
            with output_path.open("a", encoding="utf-8") as handle:
                handle.write(section)
    else:
        output_path.write_text(f"# Agent Instructions\n{section}", encoding="utf-8")
    return output_path


def write_skill(skill: Skill, agent: str, output_dir: Path) -> Path:
    if agent in {"claude", "copilot"}:
        return write_claude_like(skill, output_dir)
    if agent == "cursor":
        return write_cursor(skill, output_dir)
    if agent == "codex":
        return write_codex(skill, output_dir)
    raise ValueError(f"unknown agent: {agent}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="Skill file or directory")
    parser.add_argument("--agent", choices=AGENTS)
    parser.add_argument("--all", action="store_true", dest="all_agents", help="Compile for all agents")
    parser.add_argument("--output", "-o", type=Path, default=Path("."), help="Output directory")
    args = parser.parse_args(argv)

    if not args.source.exists():
        parser.error(f"{args.source} does not exist")
    if not args.agent and not args.all_agents:
        parser.error("specify --agent or --all")

    agents = AGENTS if args.all_agents else (args.agent,)
    skill_paths = discover_skills(args.source)
    if not skill_paths:
        parser.error(f"no skill files found in {args.source}")

    try:
        skills = [parse_skill(path) for path in skill_paths]
        for skill in skills:
            for agent in agents:
                output_path = write_skill(skill, agent, args.output)
                print(f"[{agent}] {output_path}")
    except ValueError as error:
        print(f"error: {error}", file=sys.stderr)
        return 1

    print(f"\nCompiled {len(skills)} skill(s) for {len(agents)} agent(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
