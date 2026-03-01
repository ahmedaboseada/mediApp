import 'dotenv/config';
import { z } from 'zod';

const Env = z.object({
    NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
    PORT: z.coerce.number().int().min(1).max(65535).default(3000),

    MONGODB_URI: z.string().min(1),

    JWT_ACCESS_SECRET: z.string().min(32),
    JWT_REFRESH_SECRET: z.string().min(32),
    JWT_ACCESS_TTL: z.string().default('15m'),
    JWT_REFRESH_TTL: z.string().default('30d'),

    BCRYPT_ROUNDS: z.coerce.number().int().min(10).max(15).default(12),

    RATE_LIMIT_WINDOW_MS: z.coerce.number().int().min(1000).default(60_000),
    RATE_LIMIT_MAX: z.coerce.number().int().min(1).default(60),
});

const parsed = Env.safeParse(process.env);
if (!parsed.success) {
    console.error(parsed.error.flatten());
    process.exit(1);
}

export const env = Object.freeze(parsed.data);
