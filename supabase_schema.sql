-- 결혼 플랜 대작전: Supabase 동기화 테이블 생성 스크립트 (로그인 버전)
-- Supabase 대시보드 → SQL Editor → New query 에 붙여넣고 Run 하세요. (한 번만 실행하면 됩니다)
--
-- 만약 이전에(로그인 기능 이전) whg_sync 테이블을 이미 만드셨다면 아래 한 줄을
-- 먼저 실행해서 지우고 이 스크립트를 실행해주세요. (구조가 바뀌었어요)
-- drop table if exists whg_sync;

create table if not exists whg_sync (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table whg_sync enable row level security;

-- 로그인한 본인 계정의 행만 읽고 쓸 수 있도록 제한합니다.
-- (부부가 공유 계정 하나로 로그인하는 구조이므로, 결국 행은 항상 1개만 생깁니다.)
create policy "user can read own row"
  on whg_sync for select
  to authenticated
  using (auth.uid() = user_id);

create policy "user can insert own row"
  on whg_sync for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "user can update own row"
  on whg_sync for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 추가로 해주시면 좋은 설정 (SQL 아님, 대시보드에서 클릭 한 번):
-- Authentication -> Providers -> Email -> "Confirm email"을 꺼두시면
-- 회원가입 직후 이메일 인증 없이 바로 로그인됩니다. (둘만 쓰는 계정이라 꺼도 무방)
