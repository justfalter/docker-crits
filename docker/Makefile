CRITS_DIR		= /data/crits
CRITS_DB		= $(CRITS_DIR)/crits/config/database.py
CRITS_OVERRIDES		= $(CRITS_DIR)/crits/config/overrides.py

SCRIPTS_DIR		= /docker
SCRIPTS_DB		= $(SCRIPTS_DIR)/crits/database.py
SCRIPTS_OVERRIDES	= $(SCRIPTS_DIR)/crits/overrides.py

EXTRA_CRITS_TARGETS 		=

CRITS_SERVICES			= carver_service \
				  chopshop_service \
				  crits_scripts \
				  data_miner_service \
				  entropycalc_service \
				  machoinfo_service \
				  metacap_service \
				  meta_checker \
				  office_meta_service \
				  opendns_service \
				  passivetotal_service \
				  pdfinfo_service \
				  peinfo_service \
				  relationships_service \
				  ssdeep_service \
				  taxii_service \
				  threatrecon_service \
				  timeline_service \
				  totalhash_service \
				  upx_service \
				  virustotal_service \
				  yara_service \
				  zip_meta_service

CRITS_ENABLED_SERVICES_DIR	= /data/services
CRITS_AVAILABLE_SERVICES_DIR	= /data/services-available

CRITS_SERVICE_TARGETS 		= $(addprefix /data/services/,$(CRITS_SERVICES))

ifeq ($(CRITS_INIT_DB),1)
  EXTRA_CRITS_TARGETS 	+= init_db
endif

setup_crits_links: crits_services
	ln -vsf $(SCRIPTS_DB) $(CRITS_DB)
	ln -vsf $(SCRIPTS_OVERRIDES) $(CRITS_OVERRIDES)

validate_crits_config: setup_crits_links $(CRITS_DB) $(CRITS_OVERRIDES) $(EXTRA_CRITS_TARGETS) 
	cd $(CRITS_DIR) && \
	  python manage.py validate

crits: setup_crits_links validate_crits_config

wait_for_mongodb:
	python /docker/wait_for_mongodb.py

init_db: wait_for_mongodb
	cd $(CRITS_DIR) && \
	  python manage.py create_default_collections
	cd $(CRITS_DIR) && \
	  python manage.py setconfig service_dirs $(CRITS_ENABLED_SERVICES_DIR)

$(CRITS_SERVICE_TARGETS): $(CRITS_ENABLED_SERVICES_DIR)/%: $(CRITS_AVAILABLE_SERVICES_DIR)/%
	@ln -sfv $< $@

remove_old_crits_services:
	rm -fr $(CRITS_ENABLED_SERVICES_DIR)
	mkdir -p $(CRITS_ENABLED_SERVICES_DIR)

crits_services: remove_old_crits_services $(CRITS_SERVICE_TARGETS)
