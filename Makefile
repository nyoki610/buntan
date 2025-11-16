.PHONY: sync-gh-secrets

IGNORED_FILES := \
	fastlane/6322FU89DN.json:APP_STORE_API_KEY_CONTENT \
	buntan/Resource/GoogleService-Info.plist:GOOGLE_SERVICE_INFO_PLIST_CONTENT \
	buntan/Env.xcconfig:ENV_XCCONFIG_CONTENT

sync-gh-secrets:
	@grep -E '^[A-Z_]+=' .env | while IFS='=' read -r key value; do \
		echo "$$value" | gh secret set "$$key"; \
	done
	@for entry in $(IGNORED_FILES); do \
		base64 -i $${entry%%:*} | gh secret set $${entry##*:}; \
	done
