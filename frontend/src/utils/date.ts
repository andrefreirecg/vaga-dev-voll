import { format, parseISO } from 'date-fns';
import { ptBR } from 'date-fns/locale';

export function date_to_ptbr(rawDate: string) {
  if (!rawDate) return 'Data inválida';

  try {
    const parsed = parseISO(rawDate);
    return format(parsed, "dd 'de' MMMM 'de' yyyy 'às' HH:mm", { locale: ptBR });
  } catch (e) {
    console.error('Erro ao formatar data:', e);
    return '';
  }
}
