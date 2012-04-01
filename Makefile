APPLICATIONS = nlib nodeca.core nodeca.users nodeca.forum nodeca.blogs
NODE_MODULES = $(foreach app,$(APPLICATIONS),node_modules/$(app))


node_modules/nlib:            REPO=git@github.com:nodeca/nlib.git
node_modules/nodeca.core:     REPO=git@github.com:nodeca/nodeca.core.git
node_modules/nodeca.users:    REPO=git@github.com:nodeca/nodeca.users.git
node_modules/nodeca.forum:    REPO=git@github.com:nodeca/nodeca.forum.git
node_modules/nodeca.blogs:    REPO=git@github.com:nodeca/nodeca.blogs.git


$(NODE_MODULES):
	mkdir -p node_modules
	@if test -d $@ && test ! -d $@/.git ; then \
		echo "Module $@ already exists. Remove it first." >&2 ; \
		exit 128 ; \
		fi
	test -d $@/.git || (rm -rf $@ && git clone $(REPO) $@ && cd $@ && npm install)
	cd $@ && git pull


bin/%:
	test -f $@.example && cp $@.example $@ && chmod +x $@


pull: $(NODE_MODULES)


dev-setup: pull
	$(MAKE) bin/db-dump
	$(MAKE) bin/db-restore
	npm install -g jshint ndoc


app-start:
	node ./index.js


.PHONY: $(NODE_MODULES)
