# Compliance-as-Code cho SkillNest Infra Deploy

Tài liệu này mô tả cách triển khai **compliance-as-code** cho Terraform trong repository này.

## 1) Mục tiêu

Thiết lập các kiểm soát tự động để đảm bảo hạ tầng Terraform luôn:

- Được format và validate đúng chuẩn Terraform.
- Không vi phạm các baseline security phổ biến (tfsec, Checkov).
- Tuân thủ policy nội bộ (OPA/Conftest).
- Bị chặn merge khi vi phạm compliance.

## 2) Những gì đã được thêm vào repo

- Workflow GitHub Actions: `.github/workflows/compliance.yml`
- Policy OPA (Rego): `policy/terraform/security.rego`

## 3) Luồng chạy trong CI

Workflow `Compliance as Code` sẽ chạy khi:

- `pull_request` vào `main` hoặc `stage` và có thay đổi trong `infra/**`, `infras_eks/**`, `policy/**`
- `push` lên `main` hoặc `stage` với các path tương tự

Các bước:

1. `terraform fmt -check -recursive`
2. `terraform init -backend=false`
3. `terraform validate`
4. `tfsec` scan Terraform source
5. `checkov` scan Terraform source
6. `terraform plan -out tfplan.binary` (dùng input giả cho biến nhạy cảm)
7. `terraform show -json tfplan.binary` -> `tfplan.json`
8. `conftest test tfplan.json -p policy/terraform`

## 4) Policy hiện tại (OPA)

File `policy/terraform/security.rego` đang enforce 3 nhóm chính:

- **S3 bucket phải bật server-side encryption**.
- **Security Group không được mở `0.0.0.0/0` cho SSH (22) hoặc RDP (3389)**.
- **ECS task definition phải bật CloudWatch logs**.

Bạn có thể mở rộng policy bằng cách thêm rule `deny[msg]` mới.

## 5) Cách chạy local (khuyến nghị)

> Yêu cầu: Terraform, Docker (hoặc cài trực tiếp tfsec/checkov/conftest)

```bash
terraform -chdir=infra fmt -check -recursive
terraform -chdir=infra init -backend=false
terraform -chdir=infra validate
```

Ví dụ chạy tool qua Docker:

```bash
docker run --rm -v "$PWD":/src aquasec/tfsec /src/infra

docker run --rm -v "$PWD":/src bridgecrew/checkov:latest \
  -d /src/infra --quiet
```

Với Conftest (dựa trên plan JSON):

```bash
terraform -chdir=infra plan \
  -var="project_name=skillnest" \
  -var="db_url=dummy" \
  -var="db_username=dummy" \
  -var="db_password=dummy" \
  -var="jwt_secret=dummy" \
  -var='cors_allowed_origins=["http://localhost:3000"]' \
  -var="cloudinary_cloud_name=dummy" \
  -var="cloudinary_api_key=dummy" \
  -var="cloudinary_api_secret=dummy" \
  -input=false -out tfplan.binary

terraform -chdir=infra show -json tfplan.binary > tfplan.json
conftest test tfplan.json -p policy/terraform
```

## 6) Khuyến nghị rollout theo giai đoạn

1. **Advisory mode (1-2 tuần)**: để job compliance chạy nhưng chưa block merge (có thể dùng `continue-on-error` tạm thời cho tfsec/checkov/conftest).
2. **Enforcement mode**: bỏ `continue-on-error`, bắt buộc pass trước khi merge.
3. **Branch protection**: cấu hình required status checks cho workflow compliance.

## 7) Mở rộng tiếp theo

- Thêm policy tag bắt buộc (`Environment`, `Owner`, `CostCenter`).
- Bắt buộc mã hóa cho EBS/RDS/KMS key rotation.
- Tích hợp Infracost để kiểm soát chi phí như một compliance gate.
- Đưa policy vào thư mục chuẩn theo domain: `policy/terraform/security`, `policy/terraform/tagging`, `policy/terraform/network`.