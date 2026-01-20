# Resource-based Finite State Machine — Full Reference (Code)

> **الغرض من هذا الملف**
> مرجع شامل للعودة إليه عند الارتباك.
> ليس للتقليد الأعمى، بل لفهم الصورة الكاملة.

---

## 0. Structure Overview (مطابقة للـ PHR)

```
fsm/
 ├─ fsm_controller.gd
 ├─ state.gd
 └─ states/
     ├─ idle_state.gd
     ├─ move_state.gd
     └─ attack_state.gd
entities/
 └─ test_entity.gd
debug/
 └─ fsm_debug.gd
```

---

## 1. State Interface (state.gd)
> واجهة مجردة — كل الحالات ترث منها

```gdscript
extends Resource
class_name State

signal request_transition(next_state_name: String)

func enter(owner):
    pass

func exit(owner):
    pass

func update(owner, delta: float):
    pass

func physics_update(owner, delta: float):
    pass
```

**ملاحظات:**
- لا Node references
- التواصل فقط عبر signal

---

## 2. FSM Controller (fsm_controller.gd)
> العقل المدبر — الوحيد المسموح له بتغيير الحالات

```gdscript
extends Node
class_name FSMController

@export var initial_state: State
@export var states: Dictionary # name : State

var current_state: State
var owner

func _ready():
    owner = get_parent()
    _change_state(initial_state)

func _process(delta):
    if current_state:
        current_state.update(owner, delta)

func _physics_process(delta):
    if current_state:
        current_state.physics_update(owner, delta)

func _change_state(new_state: State):
    if current_state:
        current_state.exit(owner)
        current_state.disconnect("request_transition", _on_transition_requested)

    current_state = new_state

    if current_state:
        current_state.connect("request_transition", _on_transition_requested)
        current_state.enter(owner)

func _on_transition_requested(state_name: String):
    if states.has(state_name):
        _change_state(states[state_name])
```

**ملاحظات:**
- كل الانتقالات تمر من هنا فقط
- الحالات لا تعرف بعضها

---

## 3. Example States

### 3.1 Idle State (idle_state.gd)
```gdscript
extends State
class_name IdleState

func enter(owner):
    owner.log("Enter Idle")

func update(owner, delta):
    if owner.should_move():
        emit_signal("request_transition", "Move")
```

---

### 3.2 Move State (move_state.gd)
```gdscript
extends State
class_name MoveState

func enter(owner):
    owner.log("Enter Move")

func update(owner, delta):
    owner.move(delta)

    if owner.should_attack():
        emit_signal("request_transition", "Attack")
    elif not owner.should_move():
        emit_signal("request_transition", "Idle")
```

---

### 3.3 Attack State (attack_state.gd)
```gdscript
extends State
class_name AttackState

func enter(owner):
    owner.log("Enter Attack")
    owner.start_attack()

func update(owner, delta):
    if owner.attack_finished():
        emit_signal("request_transition", "Idle")
```

---

## 4. Entity (Owner) — test_entity.gd
> الكيان لا يعرف FSM داخليًا، فقط يقدّم API

```gdscript
extends Node
class_name TestEntity

@onready var fsm: FSMController = $FSMController

func should_move() -> bool:
    return false # stub

func should_attack() -> bool:
    return false # stub

func move(delta):
    pass

func start_attack():
    pass

func attack_finished() -> bool:
    return true

func log(msg: String):
    print(msg)
```

---

## 5. Debug Overlay (fsm_debug.gd)
> لمراقبة الحالة الحالية فقط

```gdscript
extends Label

@export var fsm: FSMController

func _process(delta):
    if fsm and fsm.current_state:
        text = "State: %s" % fsm.current_state.resource_name
```

---

## 6. Mental Checklist (ارجع لها عند الارتباك)

- ❓ هل State تعرف State أخرى؟ → خطأ
- ❓ هل FSM يحتوي Gameplay؟ → خطأ
- ❓ هل Resource يخزن Node؟ → خطأ
- ❓ هل الانتقال عبر Signal؟ → صحيح

---

## 7. Exit Condition

أغلق هذا المشروع عندما:
- تستطيع كتابة FSM مشابه من الصفر
- تفهم لماذا FSM Controller أهم من State
- تستطيع شرح هذا النظام لشخص آخر بدون كود

---

**هذا الملف = خريطة الطريق عند الضياع**
لا تحفظه، افهمه.

