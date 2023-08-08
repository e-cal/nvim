return {
	s("main", {
		t({
			"int main(void) {",
			"    ",
		}),
		i(0),
		t({
			"",
			"}",
		}),
	}),
	s("mainargs", {
		t({
			"int main(int argc, char *argv[]) {",
			"    ",
		}),
		i(0),
		t({
			"",
			"}",
		}),
	}),
	s("init", {
		t({
			"#include <stdio.h>",
			"#include <stdlib.h>",
			"",
			"int main(void) {",
			"    ",
		}),
		i(0),
		t({
			"",
			"}",
		}),
	}),
	s("initargs", {
		t({
			"#include <stdio.h>",
			"#include <stdlib.h>",
			"",
			"int main(int argc, char *argv[]) {",
			"    ",
		}),
		i(0),
		t({
			"",
			"}",
		}),
	}),
}
