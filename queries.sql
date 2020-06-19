
CREATE TABLE "credit_card" (
    "card" VARCHAR(20)   NOT NULL,
    "id_card_holder" INT   NOT NULL,
    CONSTRAINT "pk_credit_card" PRIMARY KEY (
        "card"
     )
);

CREATE TABLE "card_holder" (
    "id" INT   NOT NULL,
    "name" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_card_holder" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "merchant_category" (
    "id" INT   NOT NULL,
    "name" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_merchant_category" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "merchant" (
    "id" INT   NOT NULL,
    "name" VARCHAR(50)   NOT NULL,
    "id_merchant_category" INT   NOT NULL,
    CONSTRAINT "pk_merchant" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "transaction" (
    "id" INT   NOT NULL,
    "date" TIMESTAMP   NOT NULL,
    "amount" FLOAT   NOT NULL,
    "card" VARCHAR(20)   NOT NULL,
    "id_merchant" INT   NOT NULL,
    CONSTRAINT "pk_transaction" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "credit_card" ADD CONSTRAINT "fk_credit_card_id_card_holder" FOREIGN KEY("id_card_holder")
REFERENCES "card_holder" ("id");

ALTER TABLE "merchant" ADD CONSTRAINT "fk_merchant_id_merchant_category" FOREIGN KEY("id_merchant_category")
REFERENCES "merchant_category" ("id");

ALTER TABLE "transaction" ADD CONSTRAINT "fk_transaction_card" FOREIGN KEY("card")
REFERENCES "credit_card" ("card");

ALTER TABLE "transaction" ADD CONSTRAINT "fk_transaction_id_merchant" FOREIGN KEY("id_merchant")
REFERENCES "merchant" ("id");

SELECT * FROM card_holder;
SELECT * FROM credit_card;
SELECT * FROM merchant;
SELECT * FROM merchant_category;
SELECT * FROM transaction;

ALTER TABLE card_holder
  RENAME COLUMN id TO id_card_holder;

ALTER TABLE transaction
  RENAME COLUMN id TO id_transaction;

ALTER TABLE merchant
  RENAME COLUMN id TO id_merchant;
  
ALTER TABLE merchant_category
  RENAME COLUMN id TO id_merchant_category;
  
ALTER TABLE merchant_category
  RENAME COLUMN merchant_name TO category;
  
ALTER TABLE card_holder
  RENAME COLUMN name TO card_holder_name;

CREATE VIEW transaction_by_card_holder AS
SELECT cc.id_card_holder, ch.name, t.*
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id_card_holder
GROUP BY cc.id_card_holder, ch.name, t.id_transaction
ORDER BY cc.id_card_holder;


DROP VIEW transaction_by_card_holder
SELECT * FROM transaction_by_card_holder;

CREATE VIEW aggregated_table AS
SELECT cc.id_card_holder, ch.card_holder_name, t.*, m.merchant_name, mc.*
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id_card_holder
JOIN merchant m ON t.id_merchant = m.id_merchant
JOIN merchant_category mc ON m.id_merchant_category = mc.id_merchant_category
GROUP BY cc.id_card_holder, ch.card_holder_name, t.id_transaction, m.merchant_name, mc.id_merchant_category
ORDER BY cc.id_card_holder;

SELECT * FROM aggregated_table;