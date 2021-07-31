
.PHONY: secret
secret:
	echo $(FIREBASE_CONFIG_FILE_DEVELOPMENT) | base64 -D > Posusume/GoogleService-Info-dev.plist
	echo $(FIREBASE_CONFIG_FILE_PRODUCTION) | base64 -D > Posusume/GoogleService-Info-prod.plist

graphql:
	./scripts/graphql/run.sh
