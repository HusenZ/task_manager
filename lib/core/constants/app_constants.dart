class AppConstants {
  // Storage Keys
  static const String tasksStorageKey = 'tasks_storage';
  static const String themeStorageKey = 'theme_mode';

  // App Strings
  static const String appTitle = 'Task Manager';
  static const String addTaskTitle = 'Add Task';
  static const String editTaskTitle = 'Edit Task';

  // Messages
  static const String emptyStateTitle = 'No Tasks Yet';
  static const String emptyStateMessage = 'Tap the + button to create your first task';
  static const String deleteConfirmTitle = 'Delete Task';
  static const String deleteConfirmMessage = 'Are you sure you want to delete this task?';
  static const String taskAddedMessage = 'Task added successfully';
  static const String taskUpdatedMessage = 'Task updated successfully';
  static const String taskDeletedMessage = 'Task deleted successfully';
  static const String errorMessage = 'Something went wrong. Please try again.';

  // Form Labels
  static const String titleLabel = 'Title';
  static const String titleHint = 'Enter task title';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'Enter task description (optional)';

  // Buttons
  static const String saveButton = 'Save';
  static const String cancelButton = 'Cancel';
  static const String deleteButton = 'Delete';
  static const String updateButton = 'Update';
  static const String retryButton = 'Retry';

  // Validation Messages
  static const String titleRequiredError = 'Title is required';
  static const String titleTooShortError = 'Title must be at least 3 characters';

  // Quick Actions
  static const String quickActionAddTask = 'action_add_task';
  static const String quickActionViewTasks = 'action_view_tasks';
}
