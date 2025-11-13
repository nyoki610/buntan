// Constants
const OUTPUT_KEYS = {
  BRANCH_NAME: 'branch_name',
};

const LABEL_NAMES = {
  RELEASE: 'release',
};

const BRANCH_PREFIXES = {
  RELEASE: 'release/',
};

const VALIDATION = {
  REQUIRED_PR_COUNT: 2,
};

/**
 * Validates that exactly two PRs with the release label exist and are from the same release/ branch
 * @param {Object} params
 * @param {Object} params.github - GitHub API client (Octokit)
 * @param {Object} params.context - GitHub Actions context
 * @param {Object} params.core - GitHub Actions core library
 */
module.exports = async ({github, context, core}) => {
  // Fetch all open pull requests
  const { data: prs } = await github.rest.pulls.list({
    owner: context.repo.owner,
    repo: context.repo.repo,
    state: 'open',
    per_page: 100
  });

  // Filter PRs with the release label and release/ branch prefix
  const releasePRs = prs.filter(pr =>
    pr.labels.some(label => label.name === LABEL_NAMES.RELEASE) &&
    pr.head.ref.startsWith(BRANCH_PREFIXES.RELEASE)
  );

  console.log(`🔍 Found ${releasePRs.length} PR(s) with the release label and release/ branch`);
  releasePRs.forEach(pr => {
    console.log(`  - PR #${pr.number}: ${pr.title} (${pr.head.ref} → ${pr.base.ref})`);
  });

  // Validation: Exactly 2 PRs must exist
  if (releasePRs.length !== VALIDATION.REQUIRED_PR_COUNT) {
    core.setFailed(`❌ Expected ${VALIDATION.REQUIRED_PR_COUNT} PRs with the release label and release/ branch, but found ${releasePRs.length}`);
    return;
  }

  // Validation: Both PRs must be from the same source branch
  const pr1 = releasePRs[0];
  const pr2 = releasePRs[1];

  if (pr1.head.ref !== pr2.head.ref) {
    core.setFailed(`❌ Both PRs must be from the same source branch.\n  PR #${pr1.number}: ${pr1.head.ref}\n  PR #${pr2.number}: ${pr2.head.ref}`);
    return;
  }

  console.log(`✅ All conditions met:`);
  console.log(`  - PR #${pr1.number}: ${pr1.title} (${pr1.head.ref} → ${pr1.base.ref})`);
  console.log(`  - PR #${pr2.number}: ${pr2.title} (${pr2.head.ref} → ${pr2.base.ref})`);
  console.log(`  - Source branch: ${pr1.head.ref}`);

  // Output the branch name for the merge step
  core.setOutput(OUTPUT_KEYS.BRANCH_NAME, pr1.head.ref);
};
