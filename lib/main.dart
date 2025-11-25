import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local_data_source.dart';
import 'data/repositories/task_repository_impl.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/bloc/task_event.dart';
import 'presentation/screens/add_task_screen.dart';
import 'presentation/screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize local data source
  final localDataSource = LocalDataSource(sharedPreferences: prefs);

  // Initialize repository
  final taskRepository = TaskRepositoryImpl(localDataSource: localDataSource);

  // Initialize BLoC
  final taskBloc = TaskBloc(taskRepository: taskRepository);

  // Initialize Quick Actions
  const quickActions = QuickActions();
  await _initializeQuickActions(quickActions);

  runApp(
    TaskManagerApp(
      localDataSource: localDataSource,
      taskBloc: taskBloc,
      lightTheme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      quickActions: quickActions,
    ),
  );
}

Future<void> _initializeQuickActions(QuickActions quickActions) async {
  quickActions.setShortcutItems(<ShortcutItem>[
    const ShortcutItem(
      type: AppConstants.quickActionAddTask,
      localizedTitle: 'Add New Task',
      icon: 'ic_add_task',
    ),
    const ShortcutItem(
      type: AppConstants.quickActionViewTasks,
      localizedTitle: 'View Tasks',
      icon: 'ic_view_tasks',
    ),
  ]);
}

class TaskManagerApp extends StatefulWidget {
  final LocalDataSource localDataSource;
  final TaskBloc taskBloc;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final QuickActions quickActions;

  const TaskManagerApp({
    super.key,
    required this.localDataSource,
    required this.taskBloc,
    required this.lightTheme,
    required this.darkTheme,
    required this.quickActions,
  });

  @override
  State<TaskManagerApp> createState() => TaskManagerAppState();
}

class TaskManagerAppState extends State<TaskManagerApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _setupQuickActions();
  }

  Future<void> _loadThemeMode() async {
    final themeMode = await widget.localDataSource.getThemeMode();
    if (mounted) {
      setState(() {
        _themeMode = themeMode;
      });
    }
  }

  void _setupQuickActions() {
    widget.quickActions.initialize((String shortcutType) {
      _handleQuickAction(shortcutType);
    });
  }

  void _handleQuickAction(String type) {
    final context = _navigatorKey.currentContext;
    if (context == null) return;

    if (type == AppConstants.quickActionAddTask) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: widget.taskBloc,
            child: const AddTaskScreen(),
          ),
        ),
      );
    } else if (type == AppConstants.quickActionViewTasks) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: widget.taskBloc,
            child: TaskListScreen(onToggleTheme: _toggleTheme),
          ),
        ),
        (route) => false,
      );
    }
  }

  void _toggleTheme() {
    ThemeMode newThemeMode;
    if (_themeMode == ThemeMode.light) {
      newThemeMode = ThemeMode.dark;
    } else {
      newThemeMode = ThemeMode.light;
    }

    widget.localDataSource.saveThemeMode(newThemeMode);
    setState(() {
      _themeMode = newThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: widget.lightTheme,
      darkTheme: widget.darkTheme,
      themeMode: _themeMode,
      navigatorKey: _navigatorKey,
      home: BlocProvider.value(
        value: widget.taskBloc..add(const LoadTasks()),
        child: TaskListScreen(onToggleTheme: _toggleTheme),
      ),
    );
  }
}
