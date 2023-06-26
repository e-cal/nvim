return {
    s("cell", t("# %%")),
    s("md", { t({ "# %% [markdown]", '"""', "" }), i(1), t({ "", '"""' }) }),
    s("ifmain", t('if __name__ == "__main__":')),
    s(
        "oaikey",
        t({
            "try:",
            '    with open(os.path.expanduser("~/.cache/oai"), "r") as f:',
            "        openai.api_key = f.read().strip()",
            "except:",
            '    print("Error reading openai api key from ~/.cache/oai")',
            "    exit(1)",
        })
    ),
}
