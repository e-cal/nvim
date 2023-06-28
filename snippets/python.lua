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
    s(
        "argparse",
        t({
            "import argparse",
            "",
            "parser = argparse.ArgumentParser()",
            'parser.add_argument("-a", "--arg", type=str, required=True)',
            'parser.add_argument("-b", "--bool", action="store_true")',
            'parser.add_argument("-c", "--count", type=int, default=1)',
            "args = parser.parse_args()",
        })
    ),
}
