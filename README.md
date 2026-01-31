# github-grafana-annotation

A GitHub Action that sends an annotation to Grafana

# Usage
```yaml
jobs:
  deploy:
    steps:
        - name: Annotate Grafana
          env:
            URL: ${{ secrets.GRAFANA_URL }}
            TOKEN: ${{ secrets.GRAFANA_TOKEN }}
            APP: "my-service"
            ENV: "prod"
            VERSION: ${{ steps.tag_version.outputs.newVersion }}
          uses: lydianpay/github-grafana-annotation@v0.0.1
```