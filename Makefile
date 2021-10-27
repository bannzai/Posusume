
.PHONY: secret
secret:
	echo $(FIREBASE_CONFIG_FILE) | base64 -D > Sources/GoogleService-Info.plist
	./scripts/project/secret.sh

graphql:
	./scripts/apollo/run.sh
