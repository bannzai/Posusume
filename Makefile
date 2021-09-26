
.PHONY: secret
secret:
	echo $(FIREBASE_CONFIG_FILE_DEVELOPMENT) | base64 -D > Sources/GoogleService-Info-dev.plist
	echo $(FIREBASE_CONFIG_FILE_PRODUCTION) | base64 -D > Sources/GoogleService-Info-prod.plist
	./scripts/project/secret.sh

graphql:
	./scripts/apollo/run.sh
