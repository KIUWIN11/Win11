# 🪟 Windows 11 trên Docker – GitHub Codespaces

> Chạy **Windows 11 Pro** hoàn chỉnh trong trình duyệt thông qua Docker + QEMU, hỗ trợ GitHub Codespaces và máy local.

---

## 📋 Yêu cầu hệ thống

| Thành phần | Tối thiểu | Khuyến nghị |
|------------|-----------|-------------|
| RAM (host) | 6 GB | 8 GB+ |
| CPU | 2 cores | 4 cores+ |
| Disk | 32 GB | 64 GB+ |
| KVM | Không bắt buộc | **Bắt buộc** để chạy nhanh |

> ⚠️ **GitHub Codespaces** hiện **không hỗ trợ KVM**. Windows sẽ chạy qua QEMU thuần (chậm hơn ~3-5x). Để hiệu năng tốt nhất, hãy chạy trên **máy local** hoặc **VPS có KVM**.

---

## 🚀 Cách sử dụng

### Cách 1: GitHub Codespaces (dễ nhất)

1. **Fork** repo này về tài khoản GitHub của bạn
2. Nhấn nút **"Code" → "Codespaces" → "Create codespace"**
3. Chọn máy có ít nhất **8 core / 16GB RAM** (4-core trở lên)
4. Đợi Codespace khởi động (~2 phút)
5. Mở trình duyệt → port `8006` sẽ tự động forward

### Cách 2: Máy local (hiệu năng tốt nhất)

```bash
# 1. Clone repo
git clone https://github.com/your-username/windows11-docker
cd windows11-docker

# 2. Kiểm tra KVM
ls /dev/kvm  # Phải tồn tại

# 3. Khởi động
docker compose up -d windows

# 4. Mở trình duyệt
xdg-open http://localhost:8006
```

### Cách 3: Chạy thủ công (Docker)

```bash
docker run -d \
  --name windows11 \
  -e VERSION="11" \
  -e RAM_SIZE="4G" \
  -e CPU_CORES="2" \
  -e DISK_SIZE="64G" \
  -e USERNAME="Admin" \
  -e PASSWORD="Windows11@2024" \
  -e TPM="Y" \
  -e UNATTENDED="Y" \
  -p 8006:8006 \
  -p 3389:3389 \
  --device /dev/kvm \
  --cap-add NET_ADMIN \
  -v windows-data:/storage \
  --restart unless-stopped \
  dockurr/windows:latest
```

---

## 🖥️ Kết nối với Windows

### Qua Web Browser (noVNC) – Dễ nhất
```
URL: http://localhost:8006
```
> Không cần cài thêm phần mềm. Hoạt động ngay trong trình duyệt!

### Qua RDP (Remote Desktop) – Hiệu năng tốt hơn
```
Host:     localhost
Port:     3389
Username: Admin
Password: Windows11@2024
```

**Windows:** Dùng `Remote Desktop Connection` (mstsc.exe)  
**macOS:** Dùng [Microsoft Remote Desktop](https://apps.apple.com/app/microsoft-remote-desktop/id1295203466)  
**Linux:** Dùng `rdesktop` hoặc `freerdp`

```bash
# Linux (freerdp)
xfreerdp /v:localhost:3389 /u:Admin /p:Windows11@2024 /dynamic-resolution

# macOS (Homebrew)
brew install freerdp
xfreerdp /v:localhost:3389 /u:Admin /p:Windows11@2024
```

---

## ⚙️ Tùy chỉnh cấu hình

Chỉnh sửa file `docker-compose.yml`:

```yaml
environment:
  VERSION: "11"         # 11 | 11e (Enterprise) | 10 | 2022 | ...
  RAM_SIZE: "4G"        # Tăng RAM nếu máy host đủ mạnh
  CPU_CORES: "4"        # Số nhân CPU
  DISK_SIZE: "128G"     # Dung lượng ổ C:
  LANGUAGE: "Vietnamese"
  REGION: "Asia/Ho_Chi_Minh"
```

### Các phiên bản Windows hỗ trợ

| VERSION | Hệ điều hành |
|---------|-------------|
| `11` | Windows 11 Pro *(mặc định)* |
| `11e` | Windows 11 Enterprise |
| `10` | Windows 10 Pro |
| `2022` | Windows Server 2022 |
| `2019` | Windows Server 2019 |
| `ltsc10` | Windows 10 LTSC |

---

## 📁 Chia sẻ tệp

Thư mục `./shared/` trên host sẽ xuất hiện là ổ **Z:\\** trong Windows.

```bash
# Copy file vào Windows
cp myfile.txt ./shared/

# Trong Windows, mở:  Z:\myfile.txt
```

---

## 🛠️ Lệnh quản lý

```bash
# Xem logs
docker logs -f windows11

# Theo dõi tài nguyên
docker stats windows11

# Tắt Windows (an toàn - giống shutdown)
docker stop windows11

# Khởi động lại
docker start windows11

# Xóa hoàn toàn (mất dữ liệu)
docker compose down -v

# Snapshot (backup)
docker commit windows11 windows11-backup:$(date +%Y%m%d)
```

---

## 🔧 Xử lý sự cố

### Windows khởi động chậm
- **Nguyên nhân:** Thiếu KVM acceleration
- **Giải pháp:** Chạy trên máy có KVM, hoặc tăng CPU_CORES lên 4+

### Màn hình đen sau khi kết nối
- Đợi 3-5 phút để Windows hoàn tất cài đặt lần đầu
- Kiểm tra logs: `docker logs windows11`

### Lỗi "KVM not found"
```bash
# Kiểm tra KVM
ls -la /dev/kvm

# Thêm user vào group kvm (Linux)
sudo usermod -aG kvm $USER
```

### Không truy cập được port 8006
```bash
# Kiểm tra container đang chạy
docker ps | grep windows11

# Kiểm tra port
ss -tlnp | grep 8006
```

---

## 📦 Cấu trúc project

```
windows11-codespace/
├── .devcontainer/
│   └── devcontainer.json      # Cấu hình GitHub Codespaces
├── scripts/
│   ├── setup.sh               # Script cài đặt lần đầu
│   └── start-windows.sh       # Script khởi động
├── shared/                    # Thư mục chia sẻ host ↔ Windows (Z:\)
├── docker-compose.yml         # Cấu hình Docker chính
└── README.md
```

---

## 📄 License & Credits

- **Docker Image:** [dockurr/windows](https://github.com/dockur/windows) (MIT License)
- **Virtualization:** QEMU + KVM
- **Display:** noVNC

---

> 💡 **Mẹo:** Để có trải nghiệm tốt nhất, hãy chạy trên máy Linux với KVM được bật và cấp ít nhất 8GB RAM cho container Windows.
