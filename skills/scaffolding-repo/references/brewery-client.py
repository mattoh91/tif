"""
GenAI Gateway client: unified interface for Brewery/GenAI Lab model providers.

Usage:
    client = GenAIClient(api_key=os.environ["GENAI_API_KEY"])
    text = client.generate("Summarise this document.", model="gpt-4.1", provider="openai")
"""

from __future__ import annotations

import os
from typing import Literal

import httpx
from anthropic import Anthropic
from openai import OpenAI

GATEWAY_BASE = "https://genai.heineken.com/models"

Provider = Literal["openai", "anthropic", "google", "foundry"]


class GenAIClient:
    """Unified client for the Heineken GenAI Gateway."""

    def __init__(self, api_key: str | None = None, timeout: float = 120.0) -> None:
        self.api_key = api_key or os.environ["GENAI_API_KEY"]
        self.timeout = timeout

        self._openai = OpenAI(
            base_url=f"{GATEWAY_BASE}/openai/v1",
            api_key=self.api_key,
            timeout=timeout,
        )
        self._anthropic = Anthropic(
            base_url=f"{GATEWAY_BASE}/anthropic",
            api_key=self.api_key,
            timeout=httpx.Timeout(timeout),
        )
        self._foundry = OpenAI(
            base_url=f"{GATEWAY_BASE}/foundry",
            api_key=self.api_key,
            timeout=timeout,
            default_query={"api-version": "2024-05-01-preview"},
        )
        self._http = httpx.Client(
            timeout=timeout,
            headers={"api-key": self.api_key, "Content-Type": "application/json"},
        )

    def generate(
        self,
        prompt: str,
        *,
        model: str,
        provider: Provider,
        system: str | None = None,
        max_tokens: int = 4096,
        temperature: float = 1.0,
    ) -> str:
        """Generate text from one gateway provider."""
        if provider == "openai":
            return self._generate_openai(prompt, model=model, system=system)
        if provider == "anthropic":
            return self._generate_anthropic(
                prompt,
                model=model,
                system=system,
                max_tokens=max_tokens,
                temperature=temperature,
            )
        if provider == "google":
            return self._generate_google(prompt, model=model)
        if provider == "foundry":
            return self._generate_foundry(
                prompt,
                model=model,
                system=system,
                max_tokens=max_tokens,
                temperature=temperature,
            )
        raise ValueError(f"Unknown provider: {provider}")

    def _generate_openai(self, prompt: str, *, model: str, system: str | None) -> str:
        response = self._openai.responses.create(
            model=model,
            input=prompt,
            instructions=system,
        )
        return response.output_text

    def _generate_anthropic(
        self,
        prompt: str,
        *,
        model: str,
        system: str | None,
        max_tokens: int,
        temperature: float,
    ) -> str:
        kwargs: dict[str, str] = {}
        if system:
            kwargs["system"] = system
        response = self._anthropic.messages.create(
            model=model,
            max_tokens=max_tokens,
            temperature=temperature,
            messages=[{"role": "user", "content": prompt}],
            **kwargs,
        )
        return response.content[0].text

    def _generate_google(self, prompt: str, *, model: str) -> str:
        response = self._http.post(
            f"{GATEWAY_BASE}/google/{model}:generateContent",
            json={"contents": [{"role": "user", "parts": [{"text": prompt}]}]},
        )
        response.raise_for_status()
        return response.json()["candidates"][0]["content"]["parts"][0]["text"]

    def _generate_foundry(
        self,
        prompt: str,
        *,
        model: str,
        system: str | None,
        max_tokens: int,
        temperature: float,
    ) -> str:
        messages = []
        if system:
            messages.append({"role": "system", "content": system})
        messages.append({"role": "user", "content": prompt})

        response = self._foundry.chat.completions.create(
            model=model,
            messages=messages,
            max_tokens=max_tokens,
            temperature=temperature,
        )
        return response.choices[0].message.content
