## SOLUTION:
Implement Cluster Autoscaler\
https://medium.com/@seifeddinerajhi/kubernetes-cluster-autoscaler-how-to-automatically-scale-your-cluster-for-cost-savings-and-16022ca28613

## Delete deployment:
```shell
$kubectl delete -f starter/apps/bloatware/bloatware.yml
```
## Setting IAM Open ID Connect provider for cluster "udacity-cluster":
```shell
$eksctl utils associate-iam-oidc-provider --cluster udacity-cluster --approve --region=us-east-2
```

## Create ServiceAccount role for Cluster-Autoscaler :
```shell
$eksctl create iamserviceaccount --name cluster-autoscaler --namespace kube-system --cluster udacity-cluster --attach-policy-arn "arn:aws:iam::233860181213:policy/udacity-k8s-autoscale" --approve --override-existing-serviceaccounts --region=us-east-2
$kubectl get sa cluster-autoscaler -n kube-system
```

## Deploy cluster_autoscale:
```shell
$kubectl apply -f starter/apps/bloatware/cluster_autoscale.yml
```

## Update starter/infra/eks.tf:
```
update eks.tf
  nodes_desired_size = 2
  nodes_max_size     = 8
  nodes_min_size     = 1
```

## Re-Deploy Infra:
```shell
$terraform plan
$terraform apply
```
## Re-Deploy bloatware.yml:
```shell
$kubectl apply -f starter/apps/bloatware/bloatware.yml
```