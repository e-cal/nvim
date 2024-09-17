return {
	s("cell", t("# %%")),
	s("md", { t({ "# %% [markdown]", '"""', "" }), i(1), t({ "", '"""' }) }),
	s("ifmain", t('if __name__ == "__main__":')),
	s(
		"apikey",
		fmt(
			[[
		try:
		    fp = "~/.cache/[1]"
		    with open(os.path.expanduser(fp), "r") as f:
		        api_key = f.read().strip()
		except FileNotFoundError:
		    print(f"Error reading api key from {fp}")
		    exit(1)
        ]],
			{ i(1, "key") },
            { delimiters = "[]"}
		)
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
		"dotenv",
		t({
			'with open(".env", "r") as f:',
			"    lines = f.readlines()",
			"    for line in lines:",
			'        var = line.strip().split("=", 1)',
			"        if len(var) == 2: os.environ[var[0]] = var[1]",
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
