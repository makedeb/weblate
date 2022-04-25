local deploy() = {
    name: "deploy",
    kind: "pipeline",
    type: "exec",
    triggers: {
        branch: ["master"],
        repo: ["makedeb/weblate"]
    },
    node: {server: "homelab"},
    steps: [{
        name: "deploy",
	environment: {
            weblate_email_password: {from_secret: "weblate_email_password"},
            weblate_github_token: {from_secret: "weblate_github_token"},
            weblate_postgres_password: {from_secret: "weblate_postgres_password"}
        },
        commands: [".drone/scripts/deploy.sh"]
    }]
};

[deploy()]
