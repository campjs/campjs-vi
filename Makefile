start: -/style.css
	http-server

-/style.css: index.css
	myth index.css > -/style.css

.PHONY: start
