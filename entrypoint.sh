#!/bin/bash

# Thêm các host từ hosts.additional vào /etc/hosts nếu tệp tồn tại
if [ -f /etc/hosts.additional ]; then
  echo "Đang thêm cấu hình hosts từ hosts.additional..."
  while read line; do
    # Bỏ qua dòng trống hoặc dòng comment
    if [[ -n "$line" && "$line" != \#* ]]; then
      # Phân tách IP và hostname
      ip=$(echo $line | awk '{print $1}')
      host=$(echo $line | awk '{$1=""; print $0}' | xargs)

      # Kiểm tra xem host đã tồn tại trong /etc/hosts chưa
      grep -q "$host" /etc/hosts
      if [ $? -ne 0 ]; then
        # Thêm host vào /etc/hosts bằng cách sử dụng tee (cần quyền root)
        echo "$ip $host" | tee -a /etc/hosts || {
          echo "Không thể thêm host vào /etc/hosts. Đây là lỗi được mong đợi trong môi trường Docker."
          echo "Sẽ thêm host vào biến môi trường để ứng dụng có thể sử dụng nếu cần."
          export ADDITIONAL_HOSTS="$ADDITIONAL_HOSTS\n$ip $host"
        }
      fi
    fi
  done < /etc/hosts.additional

  echo "Các host đã được thêm vào biến môi trường ADDITIONAL_HOSTS."
fi

# Chạy lệnh gốc (thường là php-fpm)
exec "$@"
