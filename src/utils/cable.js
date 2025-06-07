import { createConsumer } from '@rails/actioncable'
const url = import.meta.env.VITE_REDIS_URL ?? 'ws://localhost:3000/cable';

const cable = createConsumer(url)

export default cable
