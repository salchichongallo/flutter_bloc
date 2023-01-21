import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/ticker.dart';
import 'package:timer/timer/bloc/timer_bloc.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Timer')),
        body: Stack(
          children: [
            const Background(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: Center(child: TimerText()),
                ),
                Actions(),
              ],
            )
          ],
        ));
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration =
        context.select<TimerBloc, int>((bloc) => bloc.state.duration);
    final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final seconds = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutes:$seconds',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (state is TimerInitial) ...[
            FloatingActionButton(
              child: const Icon(Icons.play_arrow),
              onPressed: () => context
                  .read<TimerBloc>()
                  .add(TimerStarted(duration: state.duration)),
            )
          ],
          if (state is TimerRunInProgress) ...[
            FloatingActionButton(
              child: const Icon(Icons.pause),
              onPressed: () =>
                  context.read<TimerBloc>().add(const TimerPaused()),
            ),
            FloatingActionButton(
              child: const Icon(Icons.replay),
              onPressed: () =>
                  context.read<TimerBloc>().add(const TimerReset()),
            )
          ],
          if (state is TimerRunPause) ...[
            FloatingActionButton(
              child: const Icon(Icons.play_arrow),
              onPressed: () =>
                  context.read<TimerBloc>().add(const TimerResumed()),
            ),
            FloatingActionButton(
              child: const Icon(Icons.replay),
              onPressed: () =>
                  context.read<TimerBloc>().add(const TimerReset()),
            ),
          ],
          if (state is TimerRunComplete) ...[
            FloatingActionButton(
              child: const Icon(Icons.replay),
              onPressed: () =>
                  context.read<TimerBloc>().add(const TimerReset()),
            )
          ]
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.blue.shade50,
            Colors.blue.shade500,
          ])),
    );
  }
}
