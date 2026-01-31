export function parse(input: string, options?: any): any;
export class SyntaxError extends Error {
  expected: any;

  found: any;

  location: any;
}
