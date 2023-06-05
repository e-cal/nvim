return {
	s("cell", t("# %%")),
	s("md", { t({ "# %% [markdown]", '"""', "" }), i(1), t({ "", '"""' }) }),
	s("ifmain", t('if __name__ == "__main__":')),
}
