.PHONY: sync-gh-secrets prepare-release merge-release-pr

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

prepare-release:
	@if [ -z "$(bump)" ]; then \
		printf 'Usage: make prepare-release bump=<minor|major>\n' >&2; \
		exit 1; \
	elif [ "$(bump)" != "minor" ] && [ "$(bump)" != "major" ]; then \
		printf "Error: bump must be either 'minor' or 'major' (got: $(bump))\n" >&2; \
		exit 1; \
	else \
		gh workflow run prepare-release.yml -f bump_type=$(bump); \
	fi

merge-release-pr:
	gh workflow run merge-release-pr.yml
