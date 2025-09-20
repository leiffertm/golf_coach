import 'package:flutter/material.dart';
import '../app_model.dart';
import '../widgets/spacer.dart';
import '../widgets/segmented_enum.dart';
import '../utils/validators.dart';
import '../domain/enums.dart';
import '../domain/models.dart'; // <-- required for AttemptResult

class LogAttemptScreen extends StatefulWidget {
  static const route = '/log';
  final AppModel model;
  const LogAttemptScreen({super.key, required this.model});

  @override
  State<LogAttemptScreen> createState() => _LogAttemptScreenState();
}

class _LogAttemptScreenState extends State<LogAttemptScreen> {
  final _form = GlobalKey<FormState>();
  final _carryCtrl = TextEditingController();
  final _sideCtrl = TextEditingController(text: '0');
  final _notesCtrl = TextEditingController();

  Trajectory _height = Trajectory.normal;
  CurveShape _shape = CurveShape.straight;
  CurveMag _mag = CurveMag.small;
  AttemptResult _result = AttemptResult.executed;

  @override
  void initState() {
    super.initState();
    final spec = widget.model.currentSpec;
    if (spec != null) {
      _carryCtrl.text = spec.carryYards.toString();
      _height = spec.trajectory;
      _shape = spec.curveShape;
      _mag = spec.curveMag;
    }
  }

  @override
  void dispose() {
    _carryCtrl.dispose();
    _sideCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.model.currentSpec;
    return Scaffold(
      appBar: AppBar(title: const Text('Log Attempt')),
      body: spec == null
          ? const Center(child: Text('Generate a shot first.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    Text(
                        'Target: ${spec.club.label} • ${spec.carryYards} yds • ${spec.trajectory.name} • ${spec.curveMag.name} ${spec.curveShape.name}'),
                    const VSpacer(12),
                    TextFormField(
                      controller: _carryCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Actual Carry (yds)',
                          prefixIcon: Icon(Icons.straighten)),
                      keyboardType: TextInputType.number,
                      validator: Validators.requiredInt,
                    ),
                    const VSpacer(12),
                    SegmentedEnum<Trajectory>(
                      label: 'Height',
                      values: Trajectory.values,
                      value: _height,
                      toLabel: (t) => t.name,
                      onChanged: (v) => setState(() => _height = v),
                    ),
                    const VSpacer(12),
                    SegmentedEnum<CurveShape>(
                      label: 'Curve Shape',
                      values: CurveShape.values,
                      value: _shape,
                      toLabel: (t) => t.name,
                      onChanged: (v) => setState(() => _shape = v),
                    ),
                    const VSpacer(12),
                    SegmentedEnum<CurveMag>(
                      label: 'Curve Magnitude',
                      values: CurveMag.values,
                      value: _mag,
                      toLabel: (t) => t.name,
                      onChanged: (v) => setState(() => _mag = v),
                    ),
                    const VSpacer(12),
                    TextFormField(
                      controller: _sideCtrl,
                      decoration: const InputDecoration(
                        labelText: 'End Side (yds, +R / -L)',
                        prefixIcon: Icon(Icons.swap_horiz),
                      ),
                      keyboardType: TextInputType.number,
                      validator: Validators.requiredIntAllowNeg,
                    ),
                    const VSpacer(12),
                    DropdownButtonFormField<AttemptResult>(
                      initialValue: _result,
                      items: AttemptResult.values
                          .map((r) =>
                              DropdownMenuItem(value: r, child: Text(r.name)))
                          .toList(),
                      onChanged: (r) => setState(() => _result = r!),
                      decoration: const InputDecoration(labelText: 'Result'),
                    ),
                    const VSpacer(12),
                    TextFormField(
                      controller: _notesCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                          prefixIcon: Icon(Icons.notes)),
                      minLines: 2,
                      maxLines: 4,
                    ),
                    const VSpacer(16),
                    FilledButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save Attempt'),
                      onPressed: () async {
                        if (!_form.currentState!.validate()) return;

                        await widget.model.logAttempt(
                          carry: int.parse(_carryCtrl.text),
                          height: _height,
                          curveShape: _shape,
                          curveMag: _mag,
                          endSide: int.parse(_sideCtrl.text),
                          result: _result,
                          notes:
                              _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
                        );

                        await widget.model.generate();

                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
