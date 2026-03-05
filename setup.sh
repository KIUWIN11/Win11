#!/bin/bash
# ============================================================
#  setup.sh - Cài đặt môi trường lần đầu
# ============================================================

set -e

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   🪟  Windows 11 Docker Setup  🐳            ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# ── Kiểm tra Docker ────────────────────────────────────────
echo "▶ Kiểm tra Docker..."
docker --version || { echo "❌ Docker chưa được cài đặt!"; exit 1; }
docker compose version || { echo "❌ Docker Compose chưa được cài đặt!"; exit 1; }
echo "✅ Docker OK"

# ── Kiểm tra KVM ───────────────────────────────────────────
echo ""
echo "▶ Kiểm tra KVM (hardware acceleration)..."
if [ -e /dev/kvm ]; then
  echo "✅ KVM có sẵn - Windows sẽ chạy nhanh hơn!"
else
  echo "⚠️  KVM không có sẵn - Windows sẽ chạy chậm hơn (QEMU thuần)"
  echo "   GitHub Codespaces thường không hỗ trợ KVM."
  echo "   Khuyến nghị: Chạy trên máy local hoặc VPS có KVM."
fi

# ── Tạo thư mục chia sẻ ────────────────────────────────────
echo ""
echo "▶ Tạo thư mục chia sẻ..."
mkdir -p /workspace/shared
echo "✅ Thư mục /workspace/shared đã sẵn sàng"
echo "   (Trong Windows: ổ đĩa Z: sẽ trỏ tới đây)"

# ── Kiểm tra tài nguyên ────────────────────────────────────
echo ""
echo "▶ Kiểm tra tài nguyên hệ thống..."
TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
TOTAL_CPU=$(nproc)
DISK_FREE=$(df -BG /workspace | awk 'NR==2{print $4}' | tr -d 'G')

echo "   RAM:  ${TOTAL_MEM}GB (cần ≥ 6GB)"
echo "   CPU:  ${TOTAL_CPU} cores (cần ≥ 2)"
echo "   Disk: ${DISK_FREE}GB trống (cần ≥ 32GB)"

if [ "$TOTAL_MEM" -lt 6 ]; then
  echo "⚠️  RAM thấp! Windows 11 cần ít nhất 6GB RAM trên host."
fi

# ── Tải image dockurr/windows ──────────────────────────────
echo ""
echo "▶ Tải Docker image (dockurr/windows)..."
docker pull dockurr/windows:latest
echo "✅ Image đã sẵn sàng"

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║  ✅ Setup hoàn tất!                          ║"
echo "║  Chạy: bash scripts/start-windows.sh         ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
