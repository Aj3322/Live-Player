import os
from pathlib import Path

def create_project_structure(base_path):
    """Create the Flutter project folder structure"""

    # Main directories
    directories = [
        "test",
        "integration_test",
        "scripts",
        "lib/core/constants",
        "lib/core/errors",
        "lib/core/network",
        "lib/core/routes",
        "lib/core/theme",
        "lib/core/utils",
        "lib/core/widgets",
        "lib/features/video_player/data/datasources",
        "lib/features/video_player/data/models",
        "lib/features/video_player/data/repositories",
        "lib/features/video_player/domain/entities",
        "lib/features/video_player/domain/repositories",
        "lib/features/video_player/domain/usecases",
        "lib/features/video_player/presentation/bloc",
        "lib/features/video_player/presentation/providers",
        "lib/features/video_player/presentation/screens",
        "lib/features/video_player/presentation/widgets",
    ]

    # Create each directory
    for directory in directories:
        path = Path(base_path) / directory
        os.makedirs(path, exist_ok=True)
        print(f"Created directory: {path}")

    # Create empty Dart files where needed
    dart_files = [
        "lib/app.dart",
        "lib/injection_container.dart",
        "lib/core/routes/app_router.dart",
        "lib/features/video_player/presentation/screens/video_player_screen.dart",
        "lib/features/video_player/presentation/widgets/video_controls.dart",
        "lib/features/video_player/presentation/widgets/pip_overlay.dart",
    ]

    for file in dart_files:
        path = Path(base_path) / file
        with open(path, 'w') as f:
            if "screen.dart" in file:
                f.write("// TODO: Implement video player screen\n")
            elif "controls.dart" in file:
                f.write("// TODO: Implement video controls widget\n")
            elif "pip_overlay.dart" in file:
                f.write("// TODO: Implement PIP overlay widget\n")
            else:
                f.write("// TODO: Implement this file\n")
        print(f"Created file: {path}")

if __name__ == "__main__":
    project_name = input("Enter your Flutter project name (e.g., rtsp_viewer_app): ")
    create_project_structure(project_name)
    print(f"\nProject structure for '{project_name}' created successfully!")
    print("Next steps:")
    print("1. Run 'flutter create .' in the project directory to initialize Flutter")
    print("2. Add required dependencies to pubspec.yaml")
    print("3. Start implementing your features!")