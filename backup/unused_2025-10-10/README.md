# Sao lưu: backup/unused_2025-10-10

Đây là thư mục tạm lưu các file được xác định là _không dùng_ trong lần dọn dẹp ngày 2025-10-10.

Mục đích:

- Giữ an toàn các file trước khi xóa vĩnh viễn để có thể khôi phục nếu cần.

Nội dung chính:

- `assets/icons/iconstudi.png` — tệp ảnh icon (đã di chuyển từ `assets/icons/`).
- Nhiều file wrapper/compatibility đã được sao lưu (phiên bản gốc) trong các file:
  - `models_ExpandScreen_GameScreen.dart`
  - `models_ExpandScreen_StoryScreen.dart`
  - `models_ExpandScreen_translation_screen.dart`
  - `screens_controller_panel_ExpandScreen.dart`
  - `screens_controller_panel_SettingsScreen.dart`
  - `screens_controller_panel_MyLearningScreen.dart`

Hành động đã thực hiện trong dự án:

- Các wrapper hiện tại trong `lib/` đã được chuyển thành các re-export (một dòng `export ...`) để giữ tương thích import.
- Hằng `icGame` đã bị loại bỏ khỏi `lib/constants/icons.dart` vì tham chiếu tới `game.jpg` không tồn tại.
- Thư mục `backup/**` đã được loại trừ khỏi analyzer (cấu hình trong `analysis_options.yaml`) để tránh cảnh báo/lint từ các file backup.

Khôi phục file (nếu cần):

1. Khôi phục `iconstudi.png` về thư mục assets:

```powershell
Move-Item -LiteralPath 'backup\unused_2025-10-10\assets\icons\iconstudi.png' -Destination 'assets\icons\' -Force
```

2. Khôi phục một file wrapper (ví dụ):

```powershell
Copy-Item -LiteralPath 'backup\unused_2025-10-10\screens_controller_panel_ExpandScreen.dart' -Destination 'lib\screens\controller\panel\ExpandScreen.dart' -Force
```

Ghi chú:

- Giữ thư mục backup ít nhất vài phiên bản/releases để đảm bảo không mất dữ liệu nếu cần quay lại.
- Nếu muốn xóa vĩnh viễn, hãy chắc chắn kiểm tra app trên thiết bị/emulator và chạy CI tests.

Liên hệ:

- Nếu bạn muốn, tôi có thể tạo 1 PR với những thay đổi này hoặc xóa các file backup sau một thời gian an toàn.
