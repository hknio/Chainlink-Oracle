export function assertNotEmpty(property: string, value: string | undefined): string {
  assertDefined(property, value);
  if (!value) {
    throw new Error(`Empty property: ${property}`);
  }
  return value;
}

export function assertDefined<T>(property: string, obj: T): asserts obj is NonNullable<T> {
  if (obj === undefined || obj === null) {
    throw new Error(`Undefined property: ${property}`);
  }
}
