#!/bin/bash
# ============================================================
#  start-windows.sh - Khởi động Windows 11
# ============================================================

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   🪟  Khởi động Windows 11 trên Docker  🚀           ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# ── Khởi động container Windows ────────────────────────────
echo -e "${YELLOW}▶ Đang khởi động container Windows 11...${NC}"
docker compose -f /workspace/docker-compose.yml up -d windows
echo -e "${GREEN}✅ Container đã khởi động!${NC}"

# ── Chờ Windows sẵn sàng ───────────────────────────────────
echo ""
echo -e "${YELLOW}▶ Đang chờ Windows 11 khởi động (3-5 phút lần đầu)...${NC}"
echo "   Đang kiểm tra web interface..."

MAX_WAIT=300  # 5 phút
ELAPSED=0
INTERVAL=10

while [ $ELAPSED -lt $MAX_WAIT ]; do
  if curl -sf http://localhost:8006 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Windows 11 đã sẵn sàng!${NC}"
    break
  fi

  REMAINING=$((MAX_WAIT - ELAPSED))
  echo "   ⏳ Còn ${REMAINING}s... (Windows đang khởi động)"
  sleep $INTERVAL
  ELAPSED=$((ELAPSED + INTERVAL))
done

if [ $ELAPSED -ge $MAX_WAIT ]; then
  echo -e "${YELLOW}⚠️  Timeout! Kiểm tra logs: docker logs windows11${NC}"
fi

# ── Hiển thị thông tin kết nối ─────────────────────────────
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  📌 THÔNG TIN KẾT NỐI                               ║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║                                                      ║${NC}"
echo -e "${CYAN}║  🌐 Web UI (noVNC):  http://localhost:8006           ║${NC}"
echo -e "${CYAN}║  🖥️  RDP:             localhost:3389                  ║${NC}"
echo -e "${CYAN}║                                                      ║${NC}"
echo -e "${CYAN}║  👤 Tài khoản:  Admin                                ║${NC}"
echo -e "${CYAN}║  🔑 Mật khẩu:   Windows11@2024                      ║${NC}"
echo -e "${CYAN}║                                                      ║${NC}"
echo -e "${CYAN}║  📁 Thư mục chia sẻ: /workspace/shared → Z:\\        ║${NC}"
echo -e "${CYAN}║                                                      ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}💡 Lệnh hữu ích:${NC}"
echo "   docker logs -f windows11      # Xem logs real-time"
echo "   docker stats windows11        # Xem tài nguyên sử dụng"
echo "   docker stop windows11         # Tắt Windows (an toàn)"
echo "   docker compose down           # Dừng tất cả"
echo ""
