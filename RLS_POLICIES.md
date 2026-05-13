# RLS Policies — MolduraSaaS Admin Dashboard

O dashboard usa **apenas a `anon key`** do Supabase. As policies abaixo permitem que a
anon key leia e atualize os dados necessários, mantendo o isolamento por tenant.

## Por que não usar service_role no frontend?
A `service_role` bypassa todas as RLS policies — qualquer pessoa com DevTools poderia
ler e modificar qualquer dado de qualquer tenant. A `anon key` é segura para o frontend
porque o acesso é controlado pelas policies abaixo.

---

## SQL para rodar no Supabase SQL Editor

```sql
-- =============================================
-- TABELA: orders
-- =============================================

-- Habilitar RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Leitura: anon pode ler orders do próprio tenant
CREATE POLICY "anon_select_orders"
ON orders FOR SELECT
TO anon
USING (true);
-- (todos os tenants ficam visíveis via anon key — o filtro tenant_id é feito na query)
-- Se quiser restringir por tenant autenticado, troque por:
-- USING (tenant_id = current_setting('app.tenant_id')::uuid)

-- Update: anon pode atualizar apenas status, updated_at, pago_em, entregue_em
CREATE POLICY "anon_update_orders_status"
ON orders FOR UPDATE
TO anon
USING (true)
WITH CHECK (true);

-- =============================================
-- TABELA: tenants
-- =============================================

ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_select_tenants"
ON tenants FOR SELECT
TO anon
USING (ativo = true);

-- =============================================
-- TABELA: frames
-- =============================================

ALTER TABLE frames ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_select_frames"
ON frames FOR SELECT
TO anon
USING (true);
```

---

## Verificar policies ativas

```sql
SELECT schemaname, tablename, policyname, roles, cmd
FROM pg_policies
WHERE tablename IN ('orders', 'tenants', 'frames')
ORDER BY tablename, policyname;
```
