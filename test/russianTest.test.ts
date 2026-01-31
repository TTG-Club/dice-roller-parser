import { describe, expect, it } from 'vitest';

import { DiceRoller } from '../src/diceRoller';

describe('russian operators', () => {
  const cases = [
    ['3d6п1', '3d6f1'],
    ['4d6в3', '4d6k3'],
    ['4d6уб1', '4d6d1'], // Drop (UBrat)
    // ['4d6у1', '4d6>1'], // Success (Uspeh) - REMOVED
    ['4d6ул1', '4d6dh1'], // Drop Highest
    ['4d6ух1', '4d6dl1'], // Drop Lowest
    ['4d6св', '4d6sa'],
    ['4d6су', '4d6sd'],
    ['4d6совп', '4d6m'], // Match (Sovpadenie)
    ['20к20в1', '20d20k1'],
    ['20к20уб1', '20d20d1'],
    ['4кС', '4dF'], // Fate Dice with new syntax
    ['20к20ку20', '20d20cs20'], // Critical Success (KU - Kriticheskiy Uspeh)
    ['20к20кп1', '20d20cf1'], // Critical Failure (KP - Kriticheskiy Proval)
    ['2к6совпк', '2d6mt'], // Match Count (Sovpadenie Kolichestvo)
    ['низ(3/2)', 'floor(3/2)'],
    ['верх(3/2)', 'ceil(3/2)'],
    ['окр(3/2)', 'round(3/2)'],
    ['мод(-5)', 'abs(-5)'],
    ['4d6пб1', '4d6r1'], // Reroll (PereBros)
    ['4d6пр1', '4d6ro1'], // Reroll Once (Perebros Raz)
    ['4d6!п', '4d6!p'], // Penetrate (Pronikayushchiy)
  ];

  cases.forEach(([ru, en]) => {
    it(`should treat ${ru} same as ${en}`, () => {
      // Let's create a fresh roller for each to ensure same RNG sequence
      const makeRoller = () =>
        new DiceRoller((() => {
          let index = 0;

          const values = [0.84, 0.17, 0.5, 0.34, 0.1, 0.9, 0.2, 0.8];

          return () => values[index++ % values.length];
        }) as any);

      const r1 = makeRoller().roll(ru);
      const r2 = makeRoller().roll(en);

      // Compare values
      expect(r1.value).toBe(r2.value);

      // Compare basic structure properties
      expect(r1.type).toBe(r2.type);
      expect((r1 as any).successes).toBe((r2 as any).successes);
      expect((r1 as any).failures).toBe((r2 as any).failures);
    });
  });

  it('should parse complex Russian expression', () => {
    const r = new DiceRoller().roll('3к6 + 2к8'); // k is usually d in Russian (kubik)?
    // Wait, "d" in Russian is "д" or "к"?
    // In grammar: `Die = count:Integer? ("d" / "к") ...`
    // So "к" is "d".

    expect(r.valid).toBe(true);
    expect(r.value).toBeGreaterThan(0);
  });
});
