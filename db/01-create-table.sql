CREATE TABLE people (
  id uuid primary key,
  name text not null,
  email text not null,
  cpf text not null,
  birthday date not null,
  responsible_name text,
  responsible_cpf text
);

-- INSERT INTO People (id, name, email, cpf, birthday) VALUES ('046d006f-c9c4-4dfb-b378-aa7c1620efc5', 'Teste', 'teste@test.com', '123123', '12-12-2000');