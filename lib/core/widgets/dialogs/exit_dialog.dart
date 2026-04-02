import 'dart:math';

import 'package:flutter/material.dart';

Future<bool?> showExitDialog(BuildContext context) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => const _ExitDialog(),
    transitionBuilder: (ctx, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    final quote = _quitQuotes[Random().nextInt(_quitQuotes.length)];

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Quit Workout?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                quote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.45),
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Keep Going 🔥',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Quit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<String> _quitQuotes = [
  "You're so close.",
  "Don't stop now.",
  "Pain is progress.",
  "Finish what you started.",
  "Champions never quit.",
  "One more push.",
  "Your future self is watching.",
  "Make it count.",
];
// class _ExitDialog extends StatelessWidget {
//   const _ExitDialog();

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Center(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 48),
//           padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
//           decoration: BoxDecoration(
//             color: const Color(0xFF111111),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//             borderRadius: BorderRadius.circular(24),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 '🛑',
//                 style: TextStyle(fontSize: 36, decoration: TextDecoration.none),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Quit workout?',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.white,
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context, false),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 13),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.07),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.12),
//                           ),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Text(
//                           'Keep Going',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                             decoration: TextDecoration.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context, true),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 13),
//                         decoration: BoxDecoration(
//                           color: Colors.redAccent.withOpacity(0.15),
//                           border: Border.all(
//                             color: Colors.redAccent.withOpacity(0.4),
//                           ),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Text(
//                           'Quit',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.redAccent,
//                             decoration: TextDecoration.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class _ExitDialog extends StatelessWidget {
//   const _ExitDialog();

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Center(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 40), // tighter margins
//           padding: const EdgeInsets.fromLTRB(20, 24, 20, 20), // less padding
//           decoration: BoxDecoration(
//             color: const Color(0xFF111111),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//             borderRadius: BorderRadius.circular(24),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // icon
//               Container(
//                 width: 52,
//                 height: 52,
//                 decoration: BoxDecoration(
//                   color: Colors.redAccent.withOpacity(0.12),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Center(
//                   child: Text(
//                     '⚠️',
//                     style: TextStyle(
//                       fontSize: 22,
//                       decoration: TextDecoration.none,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 14),

//               const Text(
//                 'End Workout?',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.white,
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//               const SizedBox(height: 8),

//               Text(
//                 'Your progress will be lost.\nAre you sure you want to quit?',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.white.withOpacity(0.5),
//                   height: 1.5,
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context, false),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 13),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.07),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.12),
//                           ),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Text(
//                           'Keep Going',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                             decoration: TextDecoration.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context, true),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 13),
//                         decoration: BoxDecoration(
//                           color: Colors.redAccent.withOpacity(0.15),
//                           border: Border.all(
//                             color: Colors.redAccent.withOpacity(0.4),
//                           ),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Text(
//                           'End Workout',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.redAccent,
//                             decoration: TextDecoration.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
