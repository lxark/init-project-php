.SILENT: install-hooks bin get-composer composer
.SILENT: phpunit phpcs phpcpd pdepend phpmd phpcb phploc reports


# TESTS


jenkins-build: dev-install phpunit phpcs phpcpd pdepend phpmd phpcb phploc

phpunit:
	if [ -L bin/phpunit ] ; then \
		echo '-------------- phpunit ------------------' ; \
		bin/phpunit -d zend.enable_gc=0 -c app/ --debug src ; \
		echo '-------------- end phpunit ------------------' ; \
	else \
		echo 'Cannot find phpunit binary. Please run make composer-install' ; \
	fi

phploc: reports
	if [ -L bin/phploc ] ; then \
		echo '-------------- phploc ------------------' ; \
		bin/phploc --log-csv reports/phploc.csv --exclude web src ; \
		echo '-------------- end phploc ------------------' ; \
	else \
		echo 'Cannot find phploc binary. Please run make composer-install' ; \
	fi

phpcb: reports
	if [ -L bin/phpcb ] ; then \
		echo '-------------- phpcb ------------------' ; \
		bin/phpcb --source src --exclude web --output reports/code-browser ; \
		echo '-------------- end phpcb ------------------' ; \
	else \
		echo 'Cannot find phpcb binary. Please run make composer-install' ; \
	fi

phpmd: reports
	if [ -L bin/phpmd ] ; then \
		echo '-------------- phpmd ------------------' ; \
		bin/phpmd src xml codesize,unusedcode --reportfile reports/pmd.xml --exclude web ; \
		echo '-------------- end phpmd ------------------' ; \
	else \
		echo 'Cannot find phpmd binary. Please run make composer-install' ; \
	fi

pdepend: reports
	if [ -L bin/pdepend ] ; then \
		echo '-------------- pdepend ------------------' ; \
		bin/pdepend --jdepend-xml=reports/jdepend.xml --jdepend-chart=reports/dependencies.svg --overview-pyramid=reports/overview-pyramid.svg --ignore=web src; \
		echo '-------------- end pdepend ------------------' ; \
	else \
		echo 'Cannot find pdepend binary. Please run make composer-install' ; \
	fi

phpcpd: reports
	if [ -L bin/phpcpd ] ; then \
		echo '-------------- phpcpd ------------------' ; \
		bin/phpcpd --log-pmd reports/dryreports.xml src ; \
		echo '-------------- end phpcpd ------------------' ; \
	else \
		echo 'Cannot find phpcpd binary. Please run make composer-install' ; \
	fi

phpcs: reports
	if [ -L bin/phpcs ] ; then \
		echo '-------------- phpcs ------------------' ; \
		bin/phpcs src --standard=Symfony2 --extensions=php --report=checkstyle --report-file=reports/checkstyle.xml ; \
		echo '-------------- end phpcs ------------------' ; \
	else \
		echo 'Cannot find phpcs binary. Please run make composer-install' ; \
	fi

reports:
	if ! [ -d reports ] ; then \
		mkdir reports ; \
		echo 'Repertory "reports" created !' ; \
	fi



# INSTALLATION & UPDATE


install: get-composer
	php bin/composer.phar install

update: get-composer
	php bin/composer.phar update


dev-install: install-hooks get-composer
	php bin/composer.phar install --dev --verbose

dev-update: install-hooks get-composer
	php bin/composer.phar update --dev --verbose


composer: get-composer
	php bin/composer.phar

get-composer: bin
	if ! [ -f bin/composer.phar ] ; then \
		curl -sS https://getcomposer.org/installer | php -- --install-dir=bin ; \
		echo "Composer downloaded !"; \
	fi


bin:
	if ! [ -d bin ] ; then \
		mkdir bin ; \
		echo 'Repertory "bin" created !' ; \
	fi


install-hooks:
	cd .git/hooks ; \
	for i in `ls ../../.hooks` ; do \
		if ! [ -L $$i ]; then \
			ln -s ../../.hooks/$$i $$i ; \
			echo "Hook $$i installed !"; \
		else \
			echo "Hook $$i already exists."; \
		fi ; \
	done ; \
	cd -