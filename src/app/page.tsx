import { createClient } from '@/lib/supabase/server'

export default async function HomePage() {
  const supabase = await createClient()

  const { data: teams, error } = await supabase
    .from('teams')
    .select('*')
    .order('name')

  return (
    <main className="min-h-screen p-8 bg-gray-950 text-white">
      <div className="max-w-2xl mx-auto">
        <h1 className="text-3xl font-bold mb-2">Anti-Fantasy World Cup</h1>
        <p className="text-gray-400 mb-8">Supabase bağlantı testi</p>

        {error && (
          <div className="p-4 bg-red-900/30 border border-red-500 rounded-lg mb-4">
            <p className="font-semibold text-red-400">Hata:</p>
            <pre className="text-sm mt-2 overflow-auto">{JSON.stringify(error, null, 2)}</pre>
          </div>
        )}

        {teams && teams.length === 0 && (
          <div className="p-4 bg-yellow-900/30 border border-yellow-500 rounded-lg">
            <p>Teams tablosu boş. Önce Supabase&apos;de test takımları ekle.</p>
          </div>
        )}

        {teams && teams.length > 0 && (
          <div>
            <p className="text-green-400 mb-4">
              ✓ Bağlantı çalışıyor. {teams.length} takım bulundu.
            </p>
            <ul className="space-y-2">
              {teams.map((team) => (
                <li
                  key={team.id}
                  className="p-3 bg-gray-900 rounded-lg flex justify-between"
                >
                  <span className="font-medium">{team.name}</span>
                  <span className="text-gray-400 text-sm">
                    Grup {team.group_letter} · {team.code}
                  </span>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </main>
  )
}
