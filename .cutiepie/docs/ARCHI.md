# Cutiepie Architecture

## Dataflow Diagram

```xml
<mxfile host="app.diagrams.net">
  <diagram name="Cutiepie Spec-Driven Flow">
    <mxGraphModel>
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="prd" value="PRD.md&#xa;problem + user stories" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="40" y="80" width="180" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="features" value="feature_list.json&#xa;feature specs + passes" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="260" y="80" width="210" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="arch" value="ARCHI.md / ARD.md&#xa;dataflow + decisions" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="510" y="80" width="220" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="plan" value="PLAN.md&#xa;workflow checklist" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="770" y="80" width="190" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="hooks" value="Hooks&#xa;session-start / update-state" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="260" y="220" width="210" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="skills" value="Skills&#xa;planning + spec development" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="510" y="220" width="220" height="70" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## Components

| Component | Responsibility | Input Interface / DTO | Output Interface / DTO | Depends On |
| --- | --- | --- | --- | --- |
| `scripts/check-cutiepie-state.sh` | Validate canonical docs, `feature_list.json` schema, PLAN ownership, and phase sequencing. | Project root path. | State-contract report and exit code. | `.cutiepie/docs/*`, Node runtime. |
| `hooks/session-start` | Inject skill bootstrap, memory, canonical docs, and validator report. | Host SessionStart event. | Host JSON additional context. | Validator script, memory files. |
| `hooks/update-state` | Write mechanical state audit and preamble. | Manual call or lifecycle hook. | `STATE_AUDIT.md`, `PREAMBLE.md`, session note. | Validator script, git status. |
| Planning skills | Create PRD, feature list, research enrichment, architecture, sequencing, and PLAN. | User prompt and canonical docs. | Updated `.cutiepie/docs/*`. | Skill instructions. |
| Implementation skills | Implement by feature phase with internal TDD. | `feature_list.json`, `ARCHI.md`, `CONFIG.md`, `PLAN.md`. | Code changes, feature `passes`, memory, commits. | Project test harness. |
