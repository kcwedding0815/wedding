-- 결혼 플랜 대작전: Supabase 동기화 테이블 생성 스크립트
-- Supabase 대시보드 → SQL Editor → New query 에 붙여넣고 Run 하세요. (한 번만 실행하면 됩니다)

create table if not exists whg_sync (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table whg_sync enable row level security;

-- 이 앱은 로그인 없이 공개용(anon/publishable) 키로 접속합니다.
-- 데이터 자체가 결혼 준비 비교용 정보라 민감도가 낮고, 사이트 주소를 아는
-- 사람만 접근한다는 전제로 단순하게 열어둡니다(개인용 프로젝트에 흔한 패턴).
create policy "anon can read whg_sync"
  on whg_sync for select
  to anon
  using (true);

create policy "anon can insert whg_sync"
  on whg_sync for insert
  to anon
  with check (true);

create policy "anon can update whg_sync"
  on whg_sync for update
  to anon
  using (true)
  with check (true);
