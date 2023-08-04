<h1 align="center">
  <br>
  <img width="100%" src="https://raw.githubusercontent.com/viniciusborgeis/luizalabs-test/feature/add-readme/banner.png" alt="Coinbase Commerce Client">
  <br>
  Luizalabs Test
  <br>
</h1>

<h4 align="center">A olimpic games RESTful API writed in Ruby on Rails</h4>

<p align="center">
	<img src="https://raw.githubusercontent.com/viniciusborgeis/luizalabs-test/feature/add-readme/badge.svg" alt="Coverage">
	<img src="https://badgen.net/github/commits/viniciusborgeis/luizalabs-test/develop" alt="Commits">
</p>

<p align="center">
  <a href="#index">Index</a> •
  <a href="#ruby-version">Ruby Version</a> •
  <a href="#what-do-i-do">What do i do</a> •
  <a href="#clean-architecture-overview">Architecture Overview</a> •
  <a href="#endpoints">Endpoints</a> •
  <a href="#setup">Setup</a> •
  <a href="#tests">Tests</a> •
  <a href="#usage">Usage</a>
</p>
<sub>Project writed for luizalabs test, fully created in ruby on rails, follow the best clean architecture pratices.</sub>

## Index
- [Ruby Version](#version)
  - [What do i do](#what-do-i-do)
  - [Architecture Overview](#clean-architecture-overview)
    - [Clean Architecture Layers](#clean-architecture-layers)
    - [1. Presentation Layer (Controllers)](#1-presentation-layer-controllers)
    - [2. Use Case Layer (Interactors)](#2-use-case-layer-interactors)
    - [3. Data Access Layer (Gateways)](#3-data-access-layer-gateways)
    - [4. Presentation Layer (Presenters)](#4-presentation-layer-presenters)
    - [5. Frameworks & Drivers](#5-frameworks--drivers)
    - [Architecture Overview](#architecture-overview)
  - [Endpoints](#endpoints)
    - [Users](#users)
        - [Sign-up](#signup)
        - [Login](#login)
        - [Logout](#logout)
    - [Modalities](#modalities)
        - [Create](#create)
        - [Get All](#get-all)
        - [Show](#show)
    - [Competitions](#competitions)
        - [Create](#create-1)
        - [Get All](#get-all-1)
        - [Show](#show-1)
        - [Close](#close)


## Ruby Version
Ruby [3.2.2] are supported and tested.

## What do i do

Our project is a RESTful API built using Ruby on Rails for the Brazilian Olympic Committee (COB). The API's primary function is to manage and record the results of various Olympic events. Specifically, it handles competitions for events like the 100m sprint and javelin throw.

Through our API, users can:

Create a competition, providing details like the event name, event opened, and unit of measurement (e.g., seconds, meters).
Register results for a competition, including athlete details, the result value, and the unit of measurement.
Finalize a competition, marking it as closed.
Retrieve the ranking of a competition, displaying the final positions of each athlete.
The API enforces certain rules, such as not allowing result registration for closed competitions and providing partial rankings for ongoing competitions. For the javelin throw, each athlete gets three attempts, and the farthest distance is considered.

We've designed the API according to the principles of Clean Architecture and SOLID principles. We've separated the codebase into distinct layers like Models, Use Cases, Controllers, and Gateways to ensure modularity and maintainability. The API can be deployed using Docker, and we've incorporated user authentication with different roles, such as Athlete and Committee, using the Devise gem.

This project is meant to provide a flexible and robust system for managing Olympic event data, while also showcasing good software engineering practices.

## Clean Architecture Overview

Welcome to the Olympic Games API! This section provides an overview of the project's architecture based on Clean Architecture principles. The architecture promotes separation of concerns, modularity, and maintainability.

### Clean Architecture Layers

Our application follows the Clean Architecture pattern, which consists of several layers that encapsulate different aspects of the system. Each layer has a specific responsibility and interacts with other layers through defined interfaces.

### 1. Presentation Layer (Controllers)

This layer handles the presentation logic and communication with external systems. It receives HTTP requests, processes them, and returns appropriate responses. Controllers are responsible for input validation and data transformation.

**Relationships:**
- Communicates with Use Case Layer (Interactors).

### 2. Use Case Layer (Interactors)

The Use Case layer contains application-specific business rules and logic. It encapsulates use cases, which represent high-level application operations. Use cases interact with entities and gateways to achieve their goals.

**Relationships:**
- Communicates with Domain Layer (Entities).
- Communicates with Data Access Layer (Gateways).
- Communicates with Presentation Layer (Controllers).

**Relationships:**
- Communicates with Use Case Layer (Interactors).

### 3. Data Access Layer (Gateways)

The Data Access layer abstracts interactions with external data sources, such as databases or external services. Gateways provide interfaces for retrieving and storing data without exposing implementation details.

**Relationships:**
- Communicates with Use Case Layer (Interactors).

### 4. Presentation Layer (Presenters)

The Presenter layer is responsible for formatting and transforming data from the Use Case layer into a format suitable for display. It prepares data for rendering in different output formats, such as JSON or HTML.

**Relationships:**
- Communicates with Use Case Layer (Interactors).
- Communicates with Presentation Layer (Controllers).

### 5. Frameworks & Drivers

The outermost layer contains external frameworks, libraries, and tools. It includes components like the web framework (Rails), the database (ActiveRecord), and external APIs. This layer adapts and communicates with the inner layers.

**Relationships:**
- Communicates with Presentation Layer (Controllers).

### Architecture Overview

Here's an overview of how the layers interact within our Olympic Games API:

```mermaid
graph TD;
    PresentationLayer/Controller-->UseCaseLayer/Interactors;
    PresentationLayer/Controller-->PresentationLayer/Presenter;
    PresentationLayer/Presenter-->PresentationLayer/Controller
    UseCaseLayer/Interactors-->DataAccessLayer/Gateways;
    DataAccessLayer/Gateways-->Frameworks&Drivers;
    Frameworks&Drivers;
```

## Endpoints

Welcome to the Olympic Games API! This README provides a comprehensive overview of the available endpoints, along with their expected request bodies, success responses, and error responses.

### Users

#### Signup

- **Endpoint**: `/signup`
- **Http Verb**: `POST`
- **Request Body**:
    ```json
    {
        "user": {
            "email": "athlete@test.com",
            "password": "123456",
            "name": "athlete",
            "role": "athlete" // or "committee"
        }
    }
    ```
- **Success Response**:
    ```json
    {
        "status": { "code": 201, "message": "Signed up successfully." },
        "data": {
            "user": {
            "id": 1,
            "email": "athlete@test.com",
            "name": "athlete"
            }
        }
    }
    ```
- **Error Responses**:
    - Email Field Missing:
        ```json
            {
                "status": { 
                    "code": 422, 
                    "message": "User could not be created successfully." 
                    },
                "data": { 
                    "errors": "Email can't be blank and Email is invalid" 
                }
            }
        ```
    - Password Field Missing:
        ```json
            {
                "status": { 
                    "code": 422, 
                    "message": "User could not be created successfully." 
                },
                "data": { 
                    "errors": "Password can't be blank and Password is too short (minimum is 6 characters)" 
                }
            }
        ```
    - Name Field Missing:
        ```json
            {
                "status": { 
                    "code": 422, 
                    "message": "User could not be created successfully." 
                },
                "data": { 
                    "errors": "Name can't be blank" 
                }
            }
        ```
    - Invalid or Missing Role:
        ```json
            {
                "status": 422,
                "message": "Invalid or missing user role. Only accept <athlete> or <committee>"
            }
        ```
#### Login

- **Endpoint**: `/login`
- **Http Verb**: `POST`
- **Request Body**:
    ```json
    {
        "user": {
            "email": "athlete@test.com",
            "password": "123456"
        }
    }
    ```
- **Success Response**:
    ```json
    {
        "status": { 
            "code": 200, 
            "message": "Logged in successfully." 
        },
        "data": {
            "user": {
                "id": 1,
                "email": "athlete@test.com",
                "name": "athlete"
            }
        }
    }
    ```
- **Error Responses**:
    ```json
        {
            "status": 401,
            "message": "Invalid email or password."
        }
    ```

#### Logout

- **Endpoint**: `/logout`
- **Http Verb**: `DELETE`
- **Headers**: `{ "Authorization": "Bearer <TOKEN>" }`
- **Success Response**:
    ```json
    {
        "status": 200,
        "message": "Logged out successfully."
    }
    ```
- **Error Responses**:
    - Token Expired:
        ```json
        {
            "status": { 
                "code": 403, 
                "message": "The token has expired." 
            }
        }
        ```
    - Token Missing:
         ```json
        {
            "status": { 
                "code": 401, 
                "message": "A token must be passed." 
            }
        }
        ```

### Modalities
- **Endpoint**: `/modalities`

#### Create
**<sub>Only <strong>committee</strong> user can create a modality</sub>

- **Headers**: `{ "Authorization": "Bearer <TOKEN>" }`
- **Http Verb**: `POST`
- **Request Body**:
    ```json
    {
        "name": "Lançamento de Dardo",
        "unit": "meters"
    }
    ```
- **Success Response**:
    ```json
    {
	    "status": {
		    "code": 201,
		    "message": "Modality created successfully."
	    },
	    "data": {
		    "modality": {
                "id": 3,
                "name": "Lançamento de Dardo",
                "unit": "meters"
		    }
	    }
    }
    ```
- **Error Responses**:
    - Name Field Missing:
        ```json
        {
            "status": {
                "code": 422,
                "message": "Modality could not be created successfully."
            },
            "data": {
                "errors": "Name can't be blank"
            }
        }
        ```
    - Unit Field Missing:
         ```json
        {
            "status": 422,
            "message": "invalid unit."
        }
        ```
    - Wrong user type:
         ```json
        {
            "status": {
                "code": 403,
                "message": "You are not authorized to perform this action."
            }
        }
        ```

#### Get all

- **Http Verb**: `GET`
- **Success Response**:
    ```json
    {
        "status": {
            "code": 200,
            "message": "Modalities retrieved successfully."
        },
        "data": {
            "modalities": [
                {
                    "id": 1,
                    "name": "100m rasos",
                    "unit": "seconds"
                },
                {
                    "id": 2,
                    "name": "Lançamento de Dardo",
                    "unit": "meters"
                }
            ]
        }
    }
    ```

#### Show

- **Endpoint**: `/modalities/:id`
- **Http Verb**: `GET`
- **Success Response**:
    ```json
    {
        "status": {
            "code": 200,
            "message": "Modality retrieved successfully."
        },
        "data": {
            "modality": {
                "id": 2,
                "name": "Lançamento de Dardo",
                "unit": "meters"
            }
        }
    }
    ```
- **Error Responses**:
    - Missing Modality:
        ```json
        {
            "status": 404,
            "message": "Modality not found."
        }
        ```

### Competitions
- **Endpoint**: `/competitions`

#### Create
**<sub>Only <strong>committee</strong> user can create a modality</sub>

- **Headers**: `{ "Authorization": "Bearer <TOKEN>" }`
- **Http Verb**: `POST`
- **Request Body**:
    ```json
    {
        "name": "Competition 2",
        "modality_id": 1
    }
    ```
- **Success Response**:
    ```json
    {
        "status": {
            "code": 201,
            "message": "Competition created successfully."
        },
        "data": {
            "competition": {
                "id": 1,
                "name": "Running Competition",
                "closed": false,
                "modality": {
                    "name": "100m rasos",
                    "unit": "seconds"
                }
            }
        }
    }
    ```
- **Error Responses**:
    - Missing Field Name:
        ```json
        {
            "status": {
                "code": 422,
                "message": "Competition could not be created successfully."
            },
            "data": {
                "errors": "Name can't be blank"
            }
        }
        ```
    - Missing Field Modality_Id:
        ```json
        {
            "status": {
                "code": 422,
                "message": "Competition could not be created successfully."
            },
            "data": {
                "errors": "Modality must exist, Modality can't be blank, and Modality is not included in the list"
            }
        }
        ```
    - Wrong User Type:
        ```json
        {
            "status": {
                "code": 403,
                "message": "You are not authorized to perform this action."
            }
        }
        ```

#### Get all
**<sub>Winner <strong>ONLY</strong> show when competition is closed</sub>


- **Http Verb**: `GET`
- **Success Response**:
    ```json
    {
        "status": {
            "code": 200,
            "message": "Competitions retrieved successfully."
        },
        "data": {
            "competitions": [
                {
                    "id": 2,
                    "name": "Competição Precisao Dardos",
                    "closed": false,
                    "modality": {
                        "name": "Lançamento de Dardo",
                        "unit": "meters"
                    },
                    "participants": 1,
                    "winner": [],
                    "best_results": [
                        25.4,
                        25.4,
                        25.4
                    ]
                },
                {
                    "id": 1,
                    "name": "Competição 100m rasos 4",
                    "closed": true,
                    "modality": {
                        "name": "100m rasos",
                        "unit": "seconds"
                    },
                    "participants": 0,
                    "winner": [],
                    "best_results": []
                }
            ]
        }
    }
    ```

#### Show
**<sub>Winner <strong>ONLY</strong> show when competition is closed</sub>


- **Endpoint**: `/competitions/:id`
- **Http Verb**: `GET`
- **Success Response**:
    ```json
    {
        "status": {
            "code": 200,
            "message": "Competition retrieved successfully."
        },
        "data": {
            "competition": {
                "id": 2,
                "name": "Competição Precisao Dardos",
                "closed": false,
                "modality": {
                    "name": "Lançamento de Dardo",
                    "unit": "meters"
                },
                "participants": 1,
                "winner": [],
                "all_results": [
                    {
                        "id": 1,
                        "name": "athlete",
                        "value": 25.4
                    },
                    {
                        "id": 1,
                        "name": "athlete",
                        "value": 25.4
                    },
                    {
                        "id": 1,
                        "name": "athlete",
                        "value": 25.4
                    }
                ]
            }
        }
    }
    ```
- **Error Responses**:
    - Missing Competition:
        ```json
        {
            "status": 404,
            "message": "Competition not found."
        }
        ```

#### Close
**<sub>Only <strong>COMMITTEE</strong> user can close a competition</sub>


- **Endpoint**: `/competitions/:id/close`
- **Http Verb**: `PATCH`
- **Success Response**:
    ```json
    {
        "status": {
            "code": 200,
            "message": "Competition closed successfully."
        },
        "data": {
            "competition": {
                "id": 2,
                "name": "Competição Precisao Dardos",
                "closed": true,
                "modality": {
                    "name": "Lançamento de Dardo",
                    "unit": "meters"
                }
            }
        }
    }
    ```
- **Error Responses**:
    - Missing Competition:
        ```json
        {
            "status": 404,
            "message": "Competition could not be closed successfully."
        }
        ```
    - Wrong user type:
        ```json
        {
            "status": {
                "code": 403,
                "message": "You are not authorized to perform this action."
            }
        }
        ```