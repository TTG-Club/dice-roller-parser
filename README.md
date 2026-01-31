# Dice Roller & Parser / Парсер игральных костей

[![NPM version](https://img.shields.io/npm/v/@ttg-club/dice-roller-parser.svg)](https://www.npmjs.com/package/@ttg-club/dice-roller-parser)
[![License](https://img.shields.io/npm/l/@ttg-club/dice-roller-parser.svg)](https://github.com/ttg-club/dice-roller-parser/blob/master/LICENSE)

[English Version](#dice-roller--parser) | [Русская версия](#парсер-игральных-костей)

---

# Парсер игральных костей

Этот парсер игральных костей возвращает объект, содержащий компоненты броска. Он поддерживает полную спецификацию [Roll20 Dice Specification](https://roll20.zendesk.com/hc/en-us/articles/360037773133-Dice-Reference#DiceReference-Roll20DiceSpecification) (с некоторыми изменениями) и русские операторы.

## Быстрый старт

### Установка

Установите библиотеку с помощью `pnpm`:

```bash
pnpm add @ttg-club/dice-roller-parser
```

### Использование

Импортируйте библиотеку в ваш проект:

#### ES Modules
```javascript
import { DiceRoller } from '@ttg-club/dice-roller-parser';
```

#### CommonJS
```javascript
const { DiceRoller } = require('@ttg-club/dice-roller-parser');
```

Создайте экземпляр класса [`DiceRoller`](#diceroller-1) и используйте его для выполнения бросков:

```javascript
const diceRoller = new DiceRoller();

// Возвращает итоговое значение броска
// Пример: бросить 2 кубика d20 и оставить лучший результат
const roll = diceRoller.rollValue('2d20kh1');
// Или на русском:
// const roll = diceRoller.rollValue('2к20вл1');

console.log(roll);

// Возвращает объект, представляющий детали броска
const rollObject = diceRoller.roll('2d20kh1');

console.log(rollObject.value);
```

## Операторы

Библиотека поддерживает операторы на английском и русском языках.

### Список операторов

| Действие | Англ. | Рус. | Пример | Описание |
|----------|-------|------|--------|----------|
| **Dice** | `d` | `к` | `2d20`, `2к20` | Бросок кости |
| **Fate** | `dF`, `df` | `кС`, `кс` | `4dF`, `4кС` | Кости Fate |
| **Keep** | `k` | `в` | `2d20k1`, `2к20в1` | Оставить n костей |
| **Keep Highest** | `kh` | `вл` | `4d6kh3`, `4к6вл3` | Оставить n лучших |
| **Keep Lowest** | `kl` | `вх` | `2d20kl1`, `2к20вх1` | Оставить n худших |
| **Drop** | `d` | `уб` | `4d6d1`, `4к6уб1` | Убрать n костей |
| **Drop Highest** | `dh` | `ул` | `4d6dh1`, `4к6ул1` | Убрать n лучших |
| **Drop Lowest** | `dl` | `ух` | `4d6dl1`, `4к6ух1` | Убрать n худших |
| **Success** | `>`, `<`, `=` | - | `3d6>3` | Считать успехи |
| **Failure** | `f` | `п` | `3d6f1`, `3к6п1` | Считать провалы |
| **Crit Success** | `cs` | `ку` | `d20cs19`, `к20ку19` | Порог крит. успеха |
| **Crit Failure** | `cf` | `кп` | `d20cf2`, `к20кп2` | Порог крит. провала |
| **Match** | `m` | `совп` | `4d6m`, `4к6совп` | Показать совпадения |
| **Match Count** | `mt` | `совпк` | `4d6mt`, `4к6совпк` | Считать количество совпадений |
| **Reroll** | `r` | `пб` | `d6r1`, `к6пб1` | Переброс значения |
| **Reroll Once** | `ro` | `пр` | `d6ro1`, `к6пр1` | Переброс один раз |
| **Explode** | `!` | `!` | `d6!`, `к6!` | Взрыв (доп. бросок при максимуме) |
| **Compound** | `!!` | `!!` | `d6!!`, `к6!!` | Сложение (взрыв добавляется к значению) |
| **Penetrate** | `!p` | `!п` | `d6!p`, `к6!п` | Проникающий (взрыв -1) |
| **Sort Asc** | `sa` | `св` | `4d6sa`, `4к6св` | Сортировка по возрастанию |
| **Sort Desc** | `sd` | `су` | `4d6sd`, `4к6су` | Сортировка по убыванию |
| **Math** | `+`, `-`, `*`, `/`, `**`, `%` | - | `2d6+5` | Математические операции |
| **Functions** | `floor`, `ceil`, `round`, `abs` | `низ`, `верх`, `окр`, `мод` | `floor(5/2)`, `низ(5/2)` | Математические функции |

## Использование

Библиотека предоставляет два класса: [`DiceRoller`](#diceroller-1) и [`DiscordRollRenderer`](#discordrollrenderer-1).

### `DiceRoller`

Класс `DiceRoller` управляет парсингом строки с кубиками и выполнением бросков.

```javascript
// Создает новый экземпляр класса DiceRoller
const roller = new DiceRoller();
```

#### Опции конструктора

Вы можете указать свой генератор случайных чисел или ограничить количество бросков.

```javascript
// Кастомный генератор (всегда возвращает 0.5)
const customRoller = new DiceRoller(() => 0.5);

// Лимит 100 бросков на кость
const limitedRoller = new DiceRoller(null, 100);
```

#### Методы класса

- **`rollValue(input)`**: Возвращает числовое значение.
- **`roll(input)`**: Возвращает полный объект броска.
- **`parse(input)`**: Возвращает структуру парсинга без броска.

### `DiscordRollRenderer`

Класс `DiscordRollRenderer` принимает результат броска и преобразует его в строку markdown для Discord.

```javascript
const renderer = new DiscordRollRenderer();
const roll = roller.rollValue('2d20kh1');
const render = renderer.render(roll);
console.log(render);
```

## Типы возвращаемых данных

Библиотека возвращает типизированные объекты. Полные детали см. в TypeScript интерфейсах в исходном коде или в сгенерированных типах.

## Разработка

Склонируйте репозиторий и установите зависимости:

```bash
pnpm install
```

Сборка проекта:

```bash
pnpm build
```

Запуск тестов:

```bash
pnpm test
```

## Авторы

Это форк проекта [dice_roller](https://github.com/BTMorton/dice_roller) от Ben Morton.
Ранее поддерживался Frank Ali, а теперь [TTG Club](https://github.com/TTG-Club).

Основано на [3d-dice/dice-roller-parser](https://github.com/3d-dice/dice-roller-parser).

---

# Dice Roller & Parser

This dice roller is a string parser that returns an object containing the component parts of the dice roll. It supports the full [Roll20 Dice Specification](https://roll20.zendesk.com/hc/en-us/articles/360037773133-Dice-Reference#DiceReference-Roll20DiceSpecification) (with some modifications) and Russian operators.

## Quickstart

### Installation

Install the library using `pnpm`:

```bash
pnpm add @ttg-club/dice-roller-parser
```

### Usage

Import the library into your project:

#### ES Modules
```javascript
import { DiceRoller } from '@ttg-club/dice-roller-parser';
```

#### CommonJS
```javascript
const { DiceRoller } = require('@ttg-club/dice-roller-parser');
```

Then create a new instance of the [`DiceRoller`](#diceroller) class, and use it to perform some dice rolls:

```javascript
const diceRoller = new DiceRoller();

// Returns the total rolled value
// Example: roll 2 d20 dice and keep the highest
const roll = diceRoller.rollValue('2d20kh1');

console.log(roll);

// Returns an object representing the dice roll
const rollObject = diceRoller.roll('2d20kh1');

console.log(rollObject.value);
```

## Operators

This library supports both English and Russian operators.

### List of Operators

| Action | English | Russian | Example | Description |
|--------|---------|---------|---------|-------------|
| **Dice** | `d` | `к` | `2d20`, `2к20` | Roll dice |
| **Fate** | `dF`, `df` | `кС`, `кс` | `4dF`, `4кС` | Fate/Fudge dice |
| **Keep** | `k` | `в` | `2d20k1`, `2к20в1` | Keep n dice |
| **Keep Highest** | `kh` | `вл` | `4d6kh3`, `4к6вл3` | Keep n highest |
| **Keep Lowest** | `kl` | `вх` | `2d20kl1`, `2к20вх1` | Keep n lowest |
| **Drop** | `d` | `уб` | `4d6d1`, `4к6уб1` | Drop n dice |
| **Drop Highest** | `dh` | `ул` | `4d6dh1`, `4к6ул1` | Drop n highest |
| **Drop Lowest** | `dl` | `ух` | `4d6dl1`, `4к6ух1` | Drop n lowest |
| **Success** | `>`, `<`, `=` | - | `3d6>3` | Count successes |
| **Failure** | `f` | `п` | `3d6f1`, `3к6п1` | Count failures |
| **Crit Success** | `cs` | `ку` | `d20cs19`, `к20ку19` | Critical success threshold |
| **Crit Failure** | `cf` | `кп` | `d20cf2`, `к20кп2` | Critical failure threshold |
| **Match** | `m` | `совп` | `4d6m`, `4к6совп` | Show matches |
| **Match Count** | `mt` | `совпк` | `4d6mt`, `4к6совпк` | Count matches |
| **Reroll** | `r` | `пб` | `d6r1`, `к6пб1` | Reroll on value |
| **Reroll Once** | `ro` | `пр` | `d6ro1`, `к6пр1` | Reroll once |
| **Explode** | `!` | `!` | `d6!`, `к6!` | Explode |
| **Compound** | `!!` | `!!` | `d6!!`, `к6!!` | Compound (explode adds to value) |
| **Penetrate** | `!p` | `!п` | `d6!p`, `к6!п` | Penetrate (explode -1) |
| **Sort Asc** | `sa` | `св` | `4d6sa`, `4к6св` | Sort ascending |
| **Sort Desc** | `sd` | `су` | `4d6sd`, `4к6су` | Sort descending |
| **Math** | `+`, `-`, `*`, `/`, `**`, `%` | - | `2d6+5` | Math operations |
| **Functions** | `floor`, `ceil`, `round`, `abs` | `низ`, `верх`, `окр`, `мод` | `floor(5/2)`, `низ(5/2)` | Math functions |

## Usage

This library exposes two classes, a [`DiceRoller`](#diceroller) and a [`DiscordRollRenderer`](#discordrollrenderer).

### `DiceRoller`

The `DiceRoller` class manages parsing of a dice string and performing rolls based upon the result.

```javascript
// Creates a new instance of the DiceRoller class
const roller = new DiceRoller();
```

#### Constructor options

You can specify a custom random generator or limit the number of rolls.

```javascript
// Custom random generator (always returns 0.5)
const customRoller = new DiceRoller(() => 0.5);

// Limit to 100 rolls per die
const limitedRoller = new DiceRoller(null, 100);
```

#### Class Usage

- **`rollValue(input)`**: Returns the calculated number value.
- **`roll(input)`**: Returns a full object representing the roll.
- **`parse(input)`**: Returns the parsed structure without rolling.

### `DiscordRollRenderer`

The `DiscordRollRenderer` class takes a rolled input and renders it to a markdown string compatible with Discord.

```javascript
const renderer = new DiscordRollRenderer();
const roll = roller.rollValue('2d20kh1');
const render = renderer.render(roll);
console.log(render);
```

## Output Types

The library returns strongly typed objects. See TypeScript interfaces in the source code for full details.

## Development

Clone the repository and install dependencies:

```bash
pnpm install
```

Build the project:

```bash
pnpm build
```

Run tests:

```bash
pnpm test
```

## Credits

This is a fork of Ben Morton's [dice_roller](https://github.com/BTMorton/dice_roller) project.
It was previously maintained by Frank Ali and now by [TTG Club](https://github.com/TTG-Club).

Based on [3d-dice/dice-roller-parser](https://github.com/3d-dice/dice-roller-parser).
