```hcl
terraform {
  backend "s3" {
    bucket = "tf-backend-bucket-1"
    key = "terraform.tfstate"
    region = "ap-south-1"
    profile = "pratham"
  }
}
```

````
terraform init
````

**Remote To Local**

```hcl
terraform {
    backend "local" {
        path = "terraform.tfstate"

    }
}
```

````
terraform init -migrate-state
````
