CRITS_DIR		= /data/crits
CRITS_DB		= $(CRITS_DIR)/crits/config/database.py
CRITS_OVERRIDES		= $(CRITS_DIR)/crits/config/overrides.py

SCRIPTS_DIR		= /docker
SCRIPTS_DB		= $(SCRIPTS_DIR)/crits/database.py
SCRIPTS_OVERRIDES	= $(SCRIPTS_DIR)/crits/overrides.py

EXTRA_CRITS_TARGETS 		=

ifeq ($(CRITS_INIT_DB),1)
  EXTRA_CRITS_TARGETS 	+= init_db
endif

setup_crits_links:
	ln -vsf $(SCRIPTS_DB) $(CRITS_DB)
	ln -vsf $(SCRIPTS_OVERRIDES) $(CRITS_OVERRIDES)

validate_crits_config: setup_crits_links $(CRITS_DB) $(CRITS_OVERRIDES)
	cd $(CRITS_DIR) && \
	  python manage.py validate

crits: setup_crits_links $(EXTRA_CRITS_TARGETS) validate_crits_config

wait_for_mongodb:
	python /docker/wait_for_mongodb.py

init_db: wait_for_mongodb
	cd $(CRITS_DIR) && \
	  python manage.py create_default_collections
