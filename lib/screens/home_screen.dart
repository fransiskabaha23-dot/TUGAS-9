import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _showAddDialog(BuildContext context) async {
    final controller = TextEditingController();
    final provider = context.read<TaskProvider>();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tugas Baru'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Apa yang ingin dikerjakan?'),
          onSubmitted: (v) {
            provider.addTask(v);
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              provider.addTask(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // watch: widget dibangun ulang saat state berubah
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${auth.userName}'),
        actions: [
          IconButton(
            tooltip: 'Hapus yang selesai',
            icon: const Icon(Icons.delete_sweep),
            onPressed: provider.doneCount == 0 ? null : provider.clearCompleted,
          ),
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<TaskProvider>().reset();
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Aktif: ${provider.activeCount}'),
                Text('Selesai: ${provider.doneCount}'),
                Text('Total: ${provider.totalCount}'),
              ],
            ),
          ),
          SegmentedButton<TaskFilter>(
            segments: const [
              ButtonSegment(value: TaskFilter.all, label: Text('Semua')),
              ButtonSegment(value: TaskFilter.active, label: Text('Aktif')),
              ButtonSegment(value: TaskFilter.done, label: Text('Selesai')),
            ],
            selected: {provider.filter},
            onSelectionChanged: (s) => provider.setFilter(s.first),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('Belum ada tugas'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, i) {
                      final task = tasks[i];
                      return Dismissible(
                        key: ValueKey(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => context.read<TaskProvider>().removeTask(task.id),
                        child: CheckboxListTile(
                          value: task.isDone,
                          onChanged: (_) => context.read<TaskProvider>().toggleTask(task.id),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isDone ? TextDecoration.lineThrough : null,
                              color: task.isDone ? Colors.grey : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
