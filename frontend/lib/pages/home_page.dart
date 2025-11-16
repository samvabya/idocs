import 'package:flutter/material.dart';
import 'package:idocs/providers/auth_provider.dart';
import 'package:idocs/services/socket_service.dart';
import 'package:idocs/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, SocketService>(
      builder: (context, provider, socketService, child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    spacing: 15,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            Text(
                              'iDocs',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            isMobile(context)
                                ? SizedBox.shrink()
                                : Row(
                                    spacing: 10,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        provider.email.isEmpty
                                            ? 'Hello'
                                            : provider.email,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        socketService.isConnected
                                            ? Icons.cloud_done
                                            : Icons.cloud_off,
                                        color: socketService.isConnected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.red,
                                      ),
                                      Text(
                                        socketService.isConnected
                                            ? '${socketService.userCount} online'
                                            : 'Disconnected',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                            Spacer(),
                            IconButton.filled(
                              onPressed: () {
                                provider.toggleDarkMode();
                              },
                              icon: Icon(
                                provider.isDarkMode
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () async {
                                try {
                                  await provider.logout();
                                  showSnackBar("Logout successful", context);
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text('Logout'),
                            ),
                          ],
                        ),
                      ),
                      !isMobile(context)
                          ? SizedBox.shrink()
                          : Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  provider.email.isEmpty
                                      ? 'Hello'
                                      : provider.email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  socketService.isConnected
                                      ? Icons.cloud_done
                                      : Icons.cloud_off,
                                  color: socketService.isConnected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.red,
                                ),
                                Text(
                                  socketService.isConnected
                                      ? '${socketService.userCount} online'
                                      : 'Disconnected',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                      Expanded(
                        child: TextField(
                          controller: socketService.textController,
                          onChanged: (value) => socketService.onTextChanged(),
                          // expands: true,
                          maxLines: 100,
                          decoration: InputDecoration(
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            filled: true,
                            hint: Text('Start here...'),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
