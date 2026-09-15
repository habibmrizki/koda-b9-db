# Database Schemas

Dokumentasi skema database untuk sistem perpustakaan dan ecommerce.

## Sistem Perpustakaan

Source Mermaid: [db-Library.md](db-Library.md)

![Diagram database sistem perpustakaan](sistem_perputaskaan.png)

### DB Diagram

```dbml
Table MEMBER {
    id int [pk]
    name varchar(255)
}

Table LIBRARIAN {
    id int [pk]
    name varchar(255)
}

Table CATEGORIES {
    id int [pk]
    name varchar(255)
}

Table BOOKSHELF {
    id int [pk]
    code varchar(50)
    category_id int [not null, ref: > CATEGORIES.id]
}

Table BOOK {
    id int [pk]
    title varchar(255)
    category_id int [not null, ref: > CATEGORIES.id]
    bookshelf_id int [not null, ref: > BOOKSHELF.id]
}

Table BORROWING {
    id int [pk]
    member_id int [not null, ref: > MEMBER.id]
    librarian_id int [not null, ref: > LIBRARIAN.id]
    book_id int [ref: > BOOK.id]
    created_at timestamp [not null]
}
```

### Mermaid

```mermaid
erDiagram
    MEMBER {
        int id PK
        varchar name
    }

    LIBRARIAN {
        int id PK
        varchar name
    }

    CATEGORIES {
        int id PK
        varchar name
    }

    BOOKSHELF {
        int id PK
        varchar code
        int category_id FK
    }

    BOOK {
        int id PK
        varchar title
        int category_id FK
        int bookshelf_id FK
    }

    BORROWING {
        int id PK
        int member_id FK
        int librarian_id FK
        int book_id FK
        timestamp created_at
    }

    CATEGORIES ||--o{ BOOKSHELF : contains
    CATEGORIES ||--o{ BOOK : classifies
    BOOKSHELF ||--o{ BOOK : stores
    MEMBER ||--o{ BORROWING : makes
    LIBRARIAN ||--o{ BORROWING : handles
    BOOK ||--o{ BORROWING : included_in
```

SQL schema: [sistem_perputaskaan.sql](sistem_perputaskaan.sql)

## Ecommerce

Source Mermaid: [db-Ecommerce.md](db-Ecommerce.md)

![Diagram database ecommerce](e_commerce.png)

### DB Diagram

```dbml
Enum transaction_types {
    top_up
    transfer
}

Enum account_types {
    bca
    bri
    dana
}

Enum transaction_status {
    pending
    success
    failed
}

Table USER {
    id int [pk]
    name varchar(255)
}

Table TRANSACTION {
    id int [pk]
    sender_user_id int [not null, ref: > USER.id]
    received_user_id int [not null, ref: > USER.id]
    sender_account_id int [not null, ref: > INTERNAL_ACCOUNT.id]
    received_account_id int [not null, ref: > INTERNAL_ACCOUNT.id]
    amount int
    type transaction_types
    status transaction_status
    created_at timestamp
}

Table INTERNAL_ACCOUNT {
    id int [pk]
    type account_types
}

Table TRANSFER_DETAILS {
    transaction_id int [not null, unique, ref: - TRANSACTION.id]
    admin_cost int
}

Table TOPUP_DETAILS {
    transaction_id int [not null, unique, ref: - TRANSACTION.id]
    bank_name varchar(255)
}
```

### Mermaid

```mermaid
erDiagram
    USER {
        int id PK
        varchar name
    }

    TRANSACTION {
        int id PK
        int sender_user_id FK
        int received_user_id FK
        int sender_account_id FK
        int received_account_id FK
        int amount
        string type
        string status
        timestamp created_at
    }

    INTERNAL_ACCOUNT {
        int id PK
        string type
    }

    TRANSFER_DETAILS {
        int transaction_id PK, FK
        int admin_cost
    }

    TOPUP_DETAILS {
        int transaction_id PK, FK
        string bank_name
    }

    USER ||--o{ TRANSACTION : sends
    USER ||--o{ TRANSACTION : receives
    INTERNAL_ACCOUNT ||--o{ TRANSACTION : source_or_destination
    TRANSACTION ||--o| TRANSFER_DETAILS : has
    TRANSACTION ||--o| TOPUP_DETAILS : has
```
