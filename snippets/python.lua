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
			"except FileNotFoundError:",
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
			'parser.add_argument("-a", "--arg", type=str, required=True, help="")',
			'parser.add_argument("-b", "--bool", action="store_true", help="")',
			'parser.add_argument("-c", "--count", type=int, default=1)',
			"args = parser.parse_args()",
		})
	),
	s(
		"loadenv",
		t({
			"import os",
			'with open(".env", "r") as f:',
			"    lines = f.readlines()",
			"    for line in lines:",
			'        key, value = line.strip().split("=")',
			"        os.environ[key] = value",
		})
	),
	s(
		"leetcode",
		t({
			"def naive():",
			'    """naive solution"""',
			"    pass",
			"",
			"",
			'if __name__ == "__main__":',
			"    test_cases = [",
			"        ([], ),",
			"    ]",
			"",
			"    algs = [naive]",
			"    for alg in algs:",
			"        for (inp, ans) in test_cases:",
			"            out = alg(inp)",
			"            try:",
			"                assert out == ans",
			"            except:",
			"                print()",
			"                print('alg:', alg.__name__)",
			"                print('in:', inp)",
			"                print('ans:', ans)",
			"                print('out:', out)",
		})
	),
}
