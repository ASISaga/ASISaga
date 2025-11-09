# Azure Services Refactoring Guide

## Overview

This document describes the refactoring of Azure service interactions between BusinessInfinity and AgentOperatingSystem (AOS). All direct Azure SDK usage has been centralized in AOS, with BusinessInfinity now using AOS wrapper services.

## Changes Made

### 1. Enhanced AOS Azure Integration

#### New Azure Services Support in AOS
- **Azure Tables** - Full CRUD operations for table storage
- **Azure Storage Queues** - Message queuing operations  
- **Azure Service Bus** - Enterprise messaging
- **Enhanced Blob Storage** - Extended blob operations
- **Identity Management** - Centralized credential handling

#### Updated Files
- `AgentOperatingSystem/src/AgentOperatingSystem/orchestration/azure_integration.py`
  - Added TableServiceClient support
  - Added QueueServiceClient support  
  - Added ServiceBusClient support
  - Enhanced configuration and health checks

- `AgentOperatingSystem/src/AgentOperatingSystem/orchestration/business_azure_services.py` (NEW)
  - Business-specific Azure service wrapper
  - High-level operations for BusinessInfinity
  - Validation and configuration methods

### 2. BusinessInfinity Refactoring

#### Updated Storage Manager
- `BusinessInfinity/src/core/features/storage.py`
  - Removed direct Azure SDK imports
  - Uses AOS BusinessAzureServices instead
  - All methods now async
  - Backward compatibility through method signatures

#### Key Changes
```python
# OLD - Direct Azure SDK usage
from azure.data.tables import TableClient
from azure.storage.blob import BlobClient
from azure.storage.queue import QueueClient

# NEW - Uses AOS services
from AgentOperatingSystem.orchestration.business_azure_services import BusinessAzureServices

# OLD - Direct operations
table_client.upsert_entity(entity)
blob_client.upload_blob(data)
queue_client.send_message(message)

# NEW - AOS wrapper operations
await azure_services.store_boardroom_decision(decision_data)
await azure_services.upload_mentor_qa_pair(domain, question, answer)  
await azure_services.enqueue_request(message)
```

### 3. Dependency Updates

#### AOS Dependencies
- Added optional Azure dependencies in `[azure]` extra
- Includes all Azure SDKs needed by BusinessInfinity

#### BusinessInfinity Dependencies  
- Removed direct Azure SDK dependencies:
  - `azure-data-tables`
  - `azure-storage-blob`
  - `azure-storage-queue` 
  - `azure-servicebus`
  - `azure-identity`
- Updated AOS dependency to include `[azure]` extra

## Migration Guide

### For Existing Code

#### 1. Update Imports
```python
# Remove these imports
from azure.data.tables import TableClient, TableServiceClient
from azure.storage.blob import BlobClient  
from azure.storage.queue import QueueClient
from azure.servicebus import ServiceBusClient

# Add this import instead
from AgentOperatingSystem.orchestration.business_azure_services import BusinessAzureServices
```

#### 2. Initialize Services
```python
# OLD
table_client = TableClient.from_connection_string(conn_str, table_name)

# NEW  
azure_services = BusinessAzureServices()
await azure_services.azure_integration.create_table(table_name)
```

#### 3. Update Method Calls
```python
# OLD - Synchronous direct calls
table_client.upsert_entity(entity)
blob_client.upload_blob(data, overwrite=True)
queue_client.send_message(json.dumps(message))

# NEW - Asynchronous AOS calls
await azure_services.store_boardroom_decision(decision_data)
await azure_services.upload_mentor_qa_pair(domain, question, answer)
await azure_services.enqueue_request(message)
```

### Environment Configuration

AOS now handles all Azure configuration through environment variables:

```bash
# Storage Account (choose one)
AZURE_STORAGE_ACCOUNT=mystorageaccount
AZURE_STORAGE_CONNECTION_STRING=DefaultEndpointsProtocol=https;...

# Service Bus
AZURE_SERVICE_BUS_CONNECTION_STRING=Endpoint=sb://...

# Key Vault  
AZURE_KEYVAULT_URL=https://myvault.vault.azure.net/

# Identity
AZURE_SUBSCRIPTION_ID=...
AZURE_RESOURCE_GROUP=...
```

## Benefits

### 1. Centralized Azure Management
- Single point of Azure SDK usage in AOS
- Consistent error handling and logging
- Centralized credential management
- Unified health monitoring

### 2. Simplified Dependencies
- BusinessInfinity no longer needs direct Azure SDK dependencies
- Reduced dependency conflicts
- Easier version management

### 3. Enhanced Functionality
- Business-specific operations in AOS wrapper
- Better error handling and validation
- Async/await support throughout
- Comprehensive health checks

### 4. Maintainability
- Single place to update Azure SDK versions
- Consistent Azure service patterns
- Better separation of concerns

## Testing Updates

### Unit Tests
Tests should now mock AOS services instead of Azure SDK:

```python
# OLD - Mock Azure SDK
@patch('azure.data.tables.TableClient')
def test_storage_operation(mock_table):
    # Test code

# NEW - Mock AOS services  
@patch('AgentOperatingSystem.orchestration.business_azure_services.BusinessAzureServices')
async def test_storage_operation(mock_azure_services):
    # Test code
```

### Integration Tests
- Update connection string configuration
- Ensure async test patterns
- Validate AOS service initialization

## Troubleshooting

### Common Issues

#### 1. Import Errors
**Problem**: `ImportError: cannot import name 'BusinessAzureServices'`
**Solution**: Ensure AOS is installed with Azure extras: `pip install "AgentOperatingSystem[azure]"`

#### 2. Configuration Issues  
**Problem**: Azure services not initializing
**Solution**: Check environment variables are set correctly for AOS configuration

#### 3. Async/Await Issues
**Problem**: Methods expecting sync calls now async
**Solution**: Update calling code to use `await` and ensure methods are `async`

#### 4. Method Not Found
**Problem**: `NotImplementedError: Direct Azure SDK access removed`
**Solution**: Update code to use AOS wrapper methods instead of direct Azure SDK calls

## Performance Considerations

### Initialization
- AOS services initialize lazily on first use
- Connection pooling handled internally
- Credential caching for performance

### Async Operations
- All operations are now async for better concurrency
- Batch operations supported through AOS
- Connection reuse across operations

## Security

### Credential Management
- Uses Azure DefaultAzureCredential
- Supports managed identity
- No hardcoded connection strings in code

### Access Control
- AOS handles all Azure permissions
- BusinessInfinity only accesses through AOS
- Centralized audit logging

## Future Enhancements

### Planned Features
- Azure Cosmos DB support
- Azure Event Hubs integration
- Enhanced monitoring and metrics
- Automatic retry policies
- Circuit breaker patterns

### Migration Path
- Gradual migration of remaining Azure services
- Enhanced business logic abstractions
- Performance optimization