NPMBIN=./node_modules/.bin
SVGO=${NPMBIN}/svgo
JADE=${NPMBIN}/jade
JSONSTREAM=${NPMBIN}/JSONStream
CSSNEXT=${NPMBIN}/cssnext
SESSIONS_URL=http://lanyrd.com/2015/campjsnews/schedule/481ea3897063c7d5.v1.json

jade_files = $(patsubst %.jade,%.html,$(subst src/,,$(wildcard src/*.jade)))
svgs = $(filter-out isologo.svg,$(subst src/svg/,,$(wildcard src/svg/*.svg)))

default: images css pages

pages: clean_pages sessions.json $(jade_files)
css: clean_css style.css

style.css:
	@${CSSNEXT} src/css/style.css > style.css
	@echo "built style.css"

svg: $(svgs)
	@${SVGO} --config=./.svgo.yml -i - -o - < src/svg/isologo.svg > src/images/isologo.svg
	@cp src/images/* images/

images: svg
	@cp src/images/* images/

$(jade_files):
	@node makepage.js src/$(patsubst %.html,%.jade,$@) > $@
	@echo "built $@"

prepare: node_modules
	@mkdir -p images

sessions.json:
	curl -s ${SESSIONS_URL} > sessions.json

node_modules:
	@npm install

$(svgs): prepare
	@${SVGO} -i - -o - < src/svg/$@ > src/images/$@
	@echo "built $@"

clean: clean_images clean_css clean_pages
	@rm -rf pagedata/
	@rm sessions.json

clean_images:
	@rm -rf images/

clean_css:
	@rm -f style.css

clean_pages:
	@rm -f *.html

