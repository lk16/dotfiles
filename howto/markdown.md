
[Markdown cheat sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

[Mermaid](https://mermaid-js.github.io/mermaid/#/): graphs in markdown

> :warning: __If you're reading this on github and they [still](https://github.community/t/feature-request-support-mermaid-markdown-graph-diagrams-in-md-files/1922) haven't implemented mermaid support
> consider installing [one of these extensions](https://chrome.google.com/webstore/search/mermaid%20diagram).__

## Pie chart

```mermaid
pie title Who ate the cake?
         "Alice" : 9
         "Bob" : 1
         "Charlie": 3
```

## Flowchart

```mermaid
flowchart TD
    A((Circle))
    B["Escaped Text ()&quot;&amp;"]
    C((Text of C))
    A --> B & C
    B --> D
    A --> D
    E --> F
```

## Various line types

```mermaid
flowchart TD
    A --> B(Arrow)
    A --o C(Dot)
    A --x D(Cross)
    A -.-> E(Dashed line)
    A --- F(Line)
    A === G(Think line)
```

## ERD

```mermaid
erDiagram
    CAR ||--o{ NAMED-DRIVER : allows
    PERSON ||--o{ NAMED-DRIVER : is
    CAR {
        string registrationNumber
        string make
        string model
    }
    PERSON {
        string firstName
        string lastName
        int age
    }
```
